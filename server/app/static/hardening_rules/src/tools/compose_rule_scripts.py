#!/usr/bin/env python3
"""Compose a bundled CIS audit/remediation script from rule IDs.

Generates a bash script that:
1. Runs audit for all selected rules (BEFORE state)
2. Runs remediation for rules that failed
3. Runs audit again for all rules (AFTER state)
4. Generates an HTML report showing before/after comparison
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import re
from pathlib import Path
from typing import Dict, List, Optional

# --- Bash Script Şablonları ---

SCRIPT_HEADER = '''#!/usr/bin/env bash
###############################################################################
#
# CIS Benchmark Audit & Remediation Script
#
# Generated on    : {timestamp}
# Source registry : {registry}
# Rule count      : {rule_count}
#
# This script performs:
#   1. Initial audit of all selected rules (BEFORE)
#   2. Remediation for failed rules
#   3. Final audit of all rules (AFTER)
#   4. Generates HTML report with before/after comparison
#
###############################################################################

# Exit on undefined variables only, continue on errors
set -u

# Colors for output
RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
BLUE='\\033[0;34m'
NC='\\033[0m' # No Color

# Results storage
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_DIR="${{REPORT_DIR:-$HOME/cis_report_$TIMESTAMP}}"
mkdir -p "$REPORT_DIR"

# Arrays to store results
declare -A BEFORE_RESULTS
declare -A AFTER_RESULTS
declare -A BEFORE_OUTPUT
declare -A AFTER_OUTPUT

TOTAL_RULES={rule_count}
RULES_LIST=({rule_ids_quoted})

# Detailed log file
DETAILED_LOG="$REPORT_DIR/cis_detailed_report.log"

# Function to log with timestamp
log_detailed() {{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DETAILED_LOG"
}}

# Initialize detailed log
cat > "$DETAILED_LOG" << 'LOGHEADER'
################################################################################
#                   CIS BENCHMARK DETAILED EXECUTION REPORT                    #
################################################################################
LOGHEADER

log_detailed "Report Directory: $REPORT_DIR"
log_detailed "Total Rules to Check: $TOTAL_RULES"
log_detailed ""

echo -e "${{BLUE}}=============================================${{NC}}"
echo -e "${{BLUE}}  CIS Benchmark Audit & Remediation Tool${{NC}}"
echo -e "${{BLUE}}=============================================${{NC}}"
echo "Report directory: $REPORT_DIR"
echo ""

###############################################################################
# PHASE 1: INITIAL AUDIT (BEFORE)
###############################################################################
echo -e "${{YELLOW}}=== PHASE 1: Initial Audit (BEFORE) ===${{NC}}"
'''

AUDIT_FUNCTION_TEMPLATE = '''
# Audit function for rule {rule_id}
audit_{rule_id_safe}() {{
    local output
    local exit_code
    
    output=$(
{audit_content}
    ) 2>&1
    exit_code=$?
    
    echo "$output"
    return $exit_code
}}
'''

REMEDIATION_FUNCTION_TEMPLATE = '''
# Remediation function for rule {rule_id}
remediate_{rule_id_safe}() {{
{remediation_content}
}}
'''

BEFORE_AUDIT_BLOCK = '''
# --- Before Audit: {rule_id} ---
log_detailed "Auditing Rule [{index}/{total}]: {rule_id}"
echo -n "[{index}/{total}] Auditing {rule_id}... "

BEFORE_OUTPUT["{rule_id}"]=$(audit_{rule_id_safe})
BEFORE_RESULTS["{rule_id}"]=$?

if [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 0 ]; then
    echo -e "${{GREEN}}PASS${{NC}}"
    log_detailed "Status: PASS"
elif [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 2 ]; then
    echo -e "${{YELLOW}}N/A${{NC}}"
    log_detailed "Status: NOT_APPLICABLE"
else
    echo -e "${{RED}}FAIL${{NC}}"
    log_detailed "Status: FAIL"
fi
'''

REMEDIATION_BLOCK_HEADER = '''
###############################################################################
# PHASE 2: REMEDIATION
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 2: Remediation ===${NC}"

REMEDIATED_COUNT=0
for rule_id in "${RULES_LIST[@]}"; do
    # Only remediate if FAIL (exit code 1)
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 1 ]; then
        echo -e "${BLUE}Remediating $rule_id...${NC}"
        log_detailed "Remediating Rule: $rule_id"
        
        REMEDIATION_OUTPUT=""
        case "$rule_id" in
'''

REMEDIATION_CASE_TEMPLATE = '''            "{rule_id}")
                REMEDIATION_OUTPUT=$(remediate_{rule_id_safe} 2>&1)
                ;;'''

REMEDIATION_BLOCK_FOOTER = '''
        esac
        log_detailed "Remediation Output: $REMEDIATION_OUTPUT"
        ((REMEDIATED_COUNT++))
    fi
done

if [ "$REMEDIATED_COUNT" -eq 0 ]; then
    echo "No remediation needed."
fi
'''

AFTER_AUDIT_BLOCK_HEADER = '''
###############################################################################
# PHASE 3: FINAL AUDIT (AFTER)
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 3: Final Audit (AFTER) ===${NC}"
'''

AFTER_AUDIT_TEMPLATE = '''
# --- After Audit: {rule_id} ---
log_detailed "Re-auditing Rule [{index}/{total}]: {rule_id}"
echo -n "[{index}/{total}] Re-auditing {rule_id}... "

AFTER_OUTPUT["{rule_id}"]=$(audit_{rule_id_safe})
AFTER_RESULTS["{rule_id}"]=$?

if [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 0 ]; then
    echo -e "${{GREEN}}PASS${{NC}}"
    log_detailed "Status: PASS"
else
    echo -e "${{RED}}FAIL${{NC}}"
    log_detailed "Status: FAIL"
fi
'''

HTML_REPORT_GENERATOR = '''
###############################################################################
# PHASE 4: GENERATE REPORTS
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 4: Generating Reports ===${NC}"

REPORT_FILE="$REPORT_DIR/cis_report.html"
HOSTNAME=$(hostname)
REPORT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Calculate stats
BEFORE_PASS=0
BEFORE_FAIL=0
AFTER_PASS=0
AFTER_FAIL=0

for rule_id in "${RULES_LIST[@]}"; do
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ]; then ((BEFORE_PASS++)); else ((BEFORE_FAIL++)); fi
    if [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then ((AFTER_PASS++)); else ((AFTER_FAIL++)); fi
done

cat > "$REPORT_FILE" << HTMLEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CIS Benchmark Report</title>
    <style>
        body { font-family: sans-serif; background: #1a1a2e; color: #eee; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { color: #00d4ff; text-align: center; }
        .summary { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; text-align: center; }
        .pass { color: #00ff88; }
        .fail { color: #ff4757; }
        table { width: 100%; border-collapse: collapse; background: rgba(255,255,255,0.05); }
        th, td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: left; }
        th { background: rgba(0,212,255,0.2); }
        .status { padding: 5px 10px; border-radius: 15px; font-weight: bold; }
        .status.pass { background: rgba(0,255,136,0.2); color: #00ff88; }
        .status.fail { background: rgba(255,71,87,0.2); color: #ff4757; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛡️ CIS Benchmark Report</h1>
        <p style="text-align:center">Host: $HOSTNAME | Date: $REPORT_DATE</p>
        
        <div class="summary">
            <div class="card"><h3>Total</h3><h1>$TOTAL_RULES</h1></div>
            <div class="card"><h3>Before Fail</h3><h1 class="fail">$BEFORE_FAIL</h1></div>
            <div class="card"><h3>Fixed</h3><h1 class="pass">$REMEDIATED_COUNT</h1></div>
            <div class="card"><h3>After Fail</h3><h1 class="fail">$AFTER_FAIL</h1></div>
        </div>

        <table>
            <thead><tr><th>Rule ID</th><th>Before</th><th>After</th></tr></thead>
            <tbody>
HTMLEOF

for rule_id in "${RULES_LIST[@]}"; do
    b_class="fail"; b_text="FAIL"
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ]; then b_class="pass"; b_text="PASS"; fi
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 2 ]; then b_class="pass"; b_text="N/A"; fi
    
    a_class="fail"; a_text="FAIL"
    if [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then a_class="pass"; a_text="PASS"; fi
    if [ "${AFTER_RESULTS[$rule_id]}" -eq 2 ]; then a_class="pass"; a_text="N/A"; fi

    echo "<tr><td>$rule_id</td><td><span class=\"status $b_class\">$b_text</span></td><td><span class=\"status $a_class\">$a_text</span></td></tr>" >> "$REPORT_FILE"
done

echo "</tbody></table></div></body></html>" >> "$REPORT_FILE"

echo -e "${GREEN}Report generated: $REPORT_FILE${NC}"
'''

# --- Python Helper Sınıfı ---

class Registry:
    def __init__(self, entries: List[Dict[str, str]]):
        self.entries = {entry["id"]: entry for entry in entries}

    @classmethod
    def from_file(cls, path: Path) -> "Registry":
        with path.open("r", encoding="utf-8") as handle:
            entries = json.load(handle)
        return cls(entries)

    def resolve(self, rule_id: str) -> Dict[str, str]:
        if rule_id not in self.entries:
            raise KeyError(f"Rule ID '{rule_id}' not found in registry")
        return self.entries[rule_id]

def make_safe_id(rule_id: str) -> str:
    """Convert rule ID to safe bash function name."""
    return re.sub(r'[^a-zA-Z0-9]', '_', rule_id)

def read_file(path: Path) -> str:
    """Read file and strip shebang lines."""
    if not path.exists():
        return f"echo 'Error: Script not found at {path}' && exit 1"
        
    with path.open("r", encoding="utf-8") as handle:
        content = handle.read()
    
    # Shebang satırlarını temizle (#!/bin/bash vb.)
    lines = content.replace('\r\n', '\n').split('\n')
    filtered_lines = [line for line in lines if not line.strip().startswith('#!')]
    return '\n'.join(filtered_lines).strip()

# --- Ana Fonksiyon (Düzeltilmiş) ---

def compose_script(registry_path: Path, rule_ids: List[str], output_path: Path, registry_root: Optional[Path] = None) -> str:
    registry = Registry.from_file(registry_path)
    
    # Path düzeltmesi: Eğer root verilmediyse index.json'ın yanındaki klasörü kullan
    if registry_root is None:
        registry_root = registry_path.parent

    timestamp = dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
    total = len(rule_ids)
    rule_ids_quoted = " ".join([f'"{rid}"' for rid in rule_ids])

    # 1. Header
    script_parts = [
        SCRIPT_HEADER.format(
            timestamp=timestamp,
            registry=registry_path.name,
            rule_count=total,
            rule_ids_quoted=rule_ids_quoted
        )
    ]

    # 2. Define Functions (Audit & Remediation)
    for rule_id in rule_ids:
        entry = registry.resolve(rule_id)
        safe_id = make_safe_id(rule_id)
        
        # Dosya yollarını DÜZELTME kısmı burası:
        audit_path = registry_root / entry["audit"]
        audit_content = read_file(audit_path)
        
        script_parts.append(AUDIT_FUNCTION_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            audit_content=audit_content
        ))

        if entry.get("remediation"):
            rem_path = registry_root / entry["remediation"]
            rem_content = read_file(rem_path)
            script_parts.append(REMEDIATION_FUNCTION_TEMPLATE.format(
                rule_id=rule_id,
                rule_id_safe=safe_id,
                remediation_content=rem_content
            ))

    # 3. Phase 1: Initial Audit Execution Calls
    for idx, rule_id in enumerate(rule_ids):
        safe_id = make_safe_id(rule_id)
        script_parts.append(BEFORE_AUDIT_BLOCK.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            index=idx + 1,
            total=total
        ))

    # 4. Phase 2: Remediation Loop
    script_parts.append(REMEDIATION_BLOCK_HEADER)
    for rule_id in rule_ids:
        entry = registry.resolve(rule_id)
        if entry.get("remediation"):
            safe_id = make_safe_id(rule_id)
            script_parts.append(REMEDIATION_CASE_TEMPLATE.format(
                rule_id=rule_id,
                rule_id_safe=safe_id
            ))
    script_parts.append(REMEDIATION_BLOCK_FOOTER)

    # 5. Phase 3: Final Audit Execution Calls
    script_parts.append(AFTER_AUDIT_BLOCK_HEADER)
    for idx, rule_id in enumerate(rule_ids):
        safe_id = make_safe_id(rule_id)
        script_parts.append(AFTER_AUDIT_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            index=idx + 1,
            total=total
        ))

    # 6. Phase 4: HTML Reporting
    script_parts.append(HTML_REPORT_GENERATOR)

    final_script = "\n".join(script_parts)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline='\n') as handle:
        handle.write(final_script)

    return final_script

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Compose CIS audit/remediation bash script with HTML reporting")
    parser.add_argument("rule_ids", nargs="+", help="Rule IDs to include")
    parser.add_argument("--registry", type=Path, required=True, help="Path to registry JSON")
    parser.add_argument("--output", type=Path, required=True, help="Output path")
    parser.add_argument("--root", type=Path, help="Root directory for relative paths")
    return parser.parse_args()

def main() -> None:
    args = parse_args()
    compose_script(args.registry, args.rule_ids, args.output, args.root)
    print(f"Generated script: {args.output}")

if __name__ == "__main__":
    main()
