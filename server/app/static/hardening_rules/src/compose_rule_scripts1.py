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
from typing import Dict, List

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
declare -A RULE_START_TIME
declare -A RULE_END_TIME
declare -A RULE_DURATION

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
#                                                                              #
#                   CIS BENCHMARK DETAILED EXECUTION REPORT                    #
#                                                                              #
################################################################################

LOGHEADER

log_detailed "Report Directory: $REPORT_DIR"
log_detailed "Total Rules to Check: $TOTAL_RULES"
log_detailed "Execution Started: $(date '+%Y-%m-%d %H:%M:%S')"
log_detailed ""

echo -e "${{BLUE}}=============================================${{NC}}"
echo -e "${{BLUE}}  CIS Benchmark Audit & Remediation Tool${{NC}}"
echo -e "${{BLUE}}=============================================${{NC}}"
echo ""
echo "Report directory: $REPORT_DIR"
echo "Total rules to check: $TOTAL_RULES"
echo ""

###############################################################################
# PHASE 1: INITIAL AUDIT (BEFORE)
###############################################################################
echo -e "${{YELLOW}}=== PHASE 1: Initial Audit (BEFORE) ===${{NC}}"
echo ""

log_detailed "================================================================================"
log_detailed "PHASE 1: INITIAL AUDIT (BEFORE)"
log_detailed "================================================================================"
log_detailed ""

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
log_detailed "--------------------------------------------------------------------------------"
log_detailed "Auditing Rule [{index}/{total}]: {rule_id}"
RULE_START_TIME["{rule_id}"]=$(date +%s)
log_detailed "Start Time: $(date '+%Y-%m-%d %H:%M:%S')"

echo -n "[{index}/{total}] Auditing {rule_id}... "
BEFORE_OUTPUT["{rule_id}"]=$(audit_{rule_id_safe} 2>&1)
BEFORE_RESULTS["{rule_id}"]=$?

RULE_END_TIME["{rule_id}"]=$(date +%s)
RULE_DURATION["{rule_id}"]=$((RULE_END_TIME["{rule_id}"] - RULE_START_TIME["{rule_id}"]))

log_detailed "End Time: $(date '+%Y-%m-%d %H:%M:%S')"
log_detailed "Duration: ${{RULE_DURATION["{rule_id}"]}} seconds"
log_detailed "Exit Code: ${{BEFORE_RESULTS["{rule_id}"]}}"

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

log_detailed ""
log_detailed "OUTPUT:"
log_detailed "${{BEFORE_OUTPUT["{rule_id}"]}}"
log_detailed ""
'''

REMEDIATION_BLOCK = '''
###############################################################################
# PHASE 2: REMEDIATION
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 2: Remediation ===${NC}"
echo ""

log_detailed "================================================================================"
log_detailed "PHASE 2: REMEDIATION"
log_detailed "================================================================================"
log_detailed ""

REMEDIATED_COUNT=0
SKIPPED_NA_COUNT=0
for rule_id in "${RULES_LIST[@]}"; do
    # Skip if NOT_APPLICABLE (exit code 2)
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 2 ]; then
        echo -e "${YELLOW}Skipping $rule_id (NOT_APPLICABLE)${NC}"
        log_detailed "Skipping Rule: $rule_id (NOT_APPLICABLE - exit code 2)"
        ((SKIPPED_NA_COUNT++)) || true
        continue
    fi
    
    # Only remediate if FAIL (exit code 1)
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 1 ]; then
        echo -e "${BLUE}Remediating $rule_id...${NC}"
        log_detailed "--------------------------------------------------------------------------------"
        log_detailed "Remediating Rule: $rule_id"
        log_detailed "Reason: Failed in initial audit (exit code: ${BEFORE_RESULTS[$rule_id]})"
        log_detailed "Start Time: $(date '+%Y-%m-%d %H:%M:%S')"

        REMEDIATION_START=$(date +%s)
        REMEDIATION_OUTPUT=""

        case "$rule_id" in
'''

REMEDIATION_CASE_TEMPLATE = '''            "{rule_id}")
                REMEDIATION_OUTPUT=$(remediate_{rule_id_safe} 2>&1)
                REMEDIATION_EXIT=$?
                ;;'''

REMEDIATION_BLOCK_END = '''
        esac

        REMEDIATION_END=$(date +%s)
        REMEDIATION_DURATION=$((REMEDIATION_END - REMEDIATION_START))

        log_detailed "End Time: $(date '+%Y-%m-%d %H:%M:%S')"
        log_detailed "Duration: ${REMEDIATION_DURATION} seconds"
        log_detailed "Exit Code: ${REMEDIATION_EXIT:-0}"
        log_detailed ""
        log_detailed "REMEDIATION OUTPUT:"
        log_detailed "${REMEDIATION_OUTPUT:-No output captured}"
        log_detailed ""

        ((REMEDIATED_COUNT++))
    fi
done

if [ "$REMEDIATED_COUNT" -eq 0 ] && [ "$SKIPPED_NA_COUNT" -eq 0 ]; then
    echo "No remediation needed - all rules passed!"
    log_detailed "No remediation needed - all rules passed initial audit"
elif [ "$REMEDIATED_COUNT" -eq 0 ]; then
    echo "No remediation needed - rules either passed or not applicable"
    log_detailed "No remediation needed. Skipped (N/A): $SKIPPED_NA_COUNT"
else
    echo ""
    echo "Remediated $REMEDIATED_COUNT rule(s), skipped $SKIPPED_NA_COUNT (N/A)"
    log_detailed "Total rules remediated: $REMEDIATED_COUNT"
    log_detailed "Total rules skipped (N/A): $SKIPPED_NA_COUNT"
fi

log_detailed ""
'''

AFTER_AUDIT_BLOCK_HEADER = '''
###############################################################################
# PHASE 3: FINAL AUDIT (AFTER)
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 3: Final Audit (AFTER) ===${NC}"
echo ""

log_detailed "================================================================================"
log_detailed "PHASE 3: FINAL AUDIT (AFTER)"
log_detailed "================================================================================"
log_detailed ""

'''

AFTER_AUDIT_TEMPLATE = '''
# --- After Audit: {rule_id} ---
log_detailed "--------------------------------------------------------------------------------"
log_detailed "Re-auditing Rule [{index}/{total}]: {rule_id}"
AFTER_START=$(date +%s)
log_detailed "Start Time: $(date '+%Y-%m-%d %H:%M:%S')"

echo -n "[{index}/{total}] Re-auditing {rule_id}... "
AFTER_OUTPUT["{rule_id}"]=$(audit_{rule_id_safe} 2>&1)
AFTER_RESULTS["{rule_id}"]=$?

AFTER_END=$(date +%s)
AFTER_DURATION=$((AFTER_END - AFTER_START))

log_detailed "End Time: $(date '+%Y-%m-%d %H:%M:%S')"
log_detailed "Duration: ${{AFTER_DURATION}} seconds"
log_detailed "Exit Code: ${{AFTER_RESULTS["{rule_id}"]}}"

if [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 0 ]; then
    echo -e "${{GREEN}}PASS${{NC}}"
    log_detailed "Status: PASS"
elif [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 2 ]; then
    echo -e "${{YELLOW}}N/A${{NC}}"
    log_detailed "Status: NOT_APPLICABLE"
else
    echo -e "${{RED}}FAIL${{NC}}"
    log_detailed "Status: FAIL"
fi

log_detailed ""
log_detailed "OUTPUT:"
log_detailed "${{AFTER_OUTPUT["{rule_id}"]}}"
log_detailed ""

# Log comparison (handle N/A cases)
if [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 2 ] || [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 2 ]; then
    log_detailed "RESULT: NOT_APPLICABLE - Rule is not applicable to this system"
elif [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 1 ] && [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 0 ]; then
    log_detailed "RESULT: FIXED - Rule was failing, now passing after remediation"
elif [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 0 ] && [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 0 ]; then
    log_detailed "RESULT: PASSED - Rule passed both before and after"
elif [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 1 ] && [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 1 ]; then
    log_detailed "RESULT: STILL FAILING - Rule failed before and after remediation"
    log_detailed "WARNING: Remediation did not fix this rule. Manual intervention may be required."
elif [ "${{BEFORE_RESULTS["{rule_id}"]}}" -eq 0 ] && [ "${{AFTER_RESULTS["{rule_id}"]}}" -eq 1 ]; then
    log_detailed "RESULT: REGRESSION - Rule was passing, now failing (unexpected)"
    log_detailed "WARNING: This is unexpected and requires investigation!"
fi
log_detailed ""
'''

HTML_REPORT_GENERATOR = '''
###############################################################################
# PHASE 4: GENERATE REPORTS
###############################################################################
echo ""
echo -e "${YELLOW}=== PHASE 4: Generating Reports ===${NC}"
echo ""

log_detailed "================================================================================"
log_detailed "PHASE 4: GENERATING REPORTS"
log_detailed "================================================================================"
log_detailed ""

REPORT_FILE="$REPORT_DIR/cis_report.html"
HOSTNAME=$(hostname)
REPORT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
EXECUTION_END=$(date '+%Y-%m-%d %H:%M:%S')

# Count results
BEFORE_PASS=0
BEFORE_FAIL=0
BEFORE_NA=0
AFTER_PASS=0
AFTER_FAIL=0
AFTER_NA=0
FIXED_COUNT=0

for rule_id in "${RULES_LIST[@]}"; do
    # Before counts
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ]; then
        ((BEFORE_PASS++)) || true
    elif [ "${BEFORE_RESULTS[$rule_id]}" -eq 2 ]; then
        ((BEFORE_NA++)) || true
    else
        ((BEFORE_FAIL++)) || true
    fi
    # After counts
    if [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        ((AFTER_PASS++)) || true
    elif [ "${AFTER_RESULTS[$rule_id]}" -eq 2 ]; then
        ((AFTER_NA++)) || true
    else
        ((AFTER_FAIL++)) || true
    fi
    # Fixed count (only if before was FAIL and after is PASS)
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 1 ] && [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        ((FIXED_COUNT++)) || true
    fi
done

cat > "$REPORT_FILE" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS Benchmark Report</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); min-height: 100vh; padding: 20px; color: #eee; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { text-align: center; margin-bottom: 30px; color: #00d4ff; text-shadow: 0 0 20px rgba(0,212,255,0.5); }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 15px; padding: 20px; text-align: center; border: 1px solid rgba(255,255,255,0.2); }
        .card h3 { font-size: 0.9em; color: #aaa; margin-bottom: 10px; text-transform: uppercase; }
        .card .value { font-size: 2.5em; font-weight: bold; }
        .card.pass .value { color: #00ff88; }
        .card.fail .value { color: #ff4757; }
        .card.fixed .value { color: #ffd700; }
        .card.info .value { color: #00d4ff; }
        table { width: 100%; border-collapse: collapse; background: rgba(255,255,255,0.05); border-radius: 10px; overflow: hidden; }
        th { background: rgba(0,212,255,0.2); padding: 15px; text-align: left; font-weight: 600; }
        td { padding: 12px 15px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        tr:hover { background: rgba(255,255,255,0.05); }
        .status { padding: 5px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; }
        .status.pass { background: rgba(0,255,136,0.2); color: #00ff88; }
        .status.fail { background: rgba(255,71,87,0.2); color: #ff4757; }
        .status.fixed { background: rgba(255,215,0,0.2); color: #ffd700; }
        .status.na { background: rgba(128,128,128,0.2); color: #888; }
        .toggle-btn { background: rgba(0,212,255,0.2); border: none; color: #00d4ff; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8em; }
        .toggle-btn:hover { background: rgba(0,212,255,0.4); }
        .output { display: none; background: #0a0a15; padding: 10px; border-radius: 5px; margin-top: 10px; font-family: monospace; font-size: 0.85em; white-space: pre-wrap; max-height: 200px; overflow-y: auto; }
        .output.show { display: block; }
        .section { margin-bottom: 30px; }
        .section h2 { margin-bottom: 15px; color: #00d4ff; border-bottom: 2px solid rgba(0,212,255,0.3); padding-bottom: 10px; }
        .meta { text-align: center; color: #666; margin-bottom: 20px; font-size: 0.9em; }
        .arrow { margin: 0 10px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛡️ CIS Benchmark Report</h1>
        <p class="meta">Host: <strong>HOSTNAME_PLACEHOLDER</strong> | Generated: <strong>DATE_PLACEHOLDER</strong></p>
        
        <div class="summary">
            <div class="card info">
                <h3>Total Rules</h3>
                <div class="value">TOTAL_PLACEHOLDER</div>
            </div>
            <div class="card pass">
                <h3>Before: Pass</h3>
                <div class="value">BEFORE_PASS_PLACEHOLDER</div>
            </div>
            <div class="card fail">
                <h3>Before: Fail</h3>
                <div class="value">BEFORE_FAIL_PLACEHOLDER</div>
            </div>
            <div class="card fixed">
                <h3>Fixed</h3>
                <div class="value">FIXED_PLACEHOLDER</div>
            </div>
            <div class="card pass">
                <h3>After: Pass</h3>
                <div class="value">AFTER_PASS_PLACEHOLDER</div>
            </div>
            <div class="card fail">
                <h3>After: Fail</h3>
                <div class="value">AFTER_FAIL_PLACEHOLDER</div>
            </div>
        </div>

        <div class="section">
            <h2>📋 Detailed Results</h2>
            <table>
                <thead>
                    <tr>
                        <th>Rule ID</th>
                        <th>Before</th>
                        <th></th>
                        <th>After</th>
                        <th>Status</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
HTMLEOF

# Generate table rows
for rule_id in "${RULES_LIST[@]}"; do
    before_status="FAIL"
    before_class="fail"
    after_status="FAIL"
    after_class="fail"
    overall_status="FAIL"
    overall_class="fail"
    
    # Before status
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ]; then
        before_status="PASS"
        before_class="pass"
    elif [ "${BEFORE_RESULTS[$rule_id]}" -eq 2 ]; then
        before_status="N/A"
        before_class="na"
    fi
    
    # After status
    if [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        after_status="PASS"
        after_class="pass"
    elif [ "${AFTER_RESULTS[$rule_id]}" -eq 2 ]; then
        after_status="N/A"
        after_class="na"
    fi
    
    # Overall status
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 2 ] || [ "${AFTER_RESULTS[$rule_id]}" -eq 2 ]; then
        overall_status="N/A"
        overall_class="na"
    elif [ "${BEFORE_RESULTS[$rule_id]}" -eq 1 ] && [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        overall_status="FIXED"
        overall_class="fixed"
    elif [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        overall_status="PASS"
        overall_class="pass"
    fi
    
    # Escape HTML in output
    before_out=$(echo "${BEFORE_OUTPUT[$rule_id]}" | sed 's/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g; s/"/\\&quot;/g')
    after_out=$(echo "${AFTER_OUTPUT[$rule_id]}" | sed 's/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g; s/"/\\&quot;/g')
    
    cat >> "$REPORT_FILE" << ROWEOF
                    <tr>
                        <td><strong>$rule_id</strong></td>
                        <td><span class="status $before_class">$before_status</span></td>
                        <td class="arrow">→</td>
                        <td><span class="status $after_class">$after_status</span></td>
                        <td><span class="status $overall_class">$overall_status</span></td>
                        <td>
                            <button class="toggle-btn" onclick="this.nextElementSibling.classList.toggle('show')">Show Output</button>
                            <div class="output"><strong>Before:</strong>
$before_out

<strong>After:</strong>
$after_out</div>
                        </td>
                    </tr>
ROWEOF
done

cat >> "$REPORT_FILE" << 'HTMLEOF'
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
HTMLEOF

# Replace placeholders
sed -i "s/HOSTNAME_PLACEHOLDER/$HOSTNAME/g" "$REPORT_FILE"
sed -i "s/DATE_PLACEHOLDER/$REPORT_DATE/g" "$REPORT_FILE"
sed -i "s/TOTAL_PLACEHOLDER/$TOTAL_RULES/g" "$REPORT_FILE"
sed -i "s/BEFORE_PASS_PLACEHOLDER/$BEFORE_PASS/g" "$REPORT_FILE"
sed -i "s/BEFORE_FAIL_PLACEHOLDER/$BEFORE_FAIL/g" "$REPORT_FILE"
sed -i "s/AFTER_PASS_PLACEHOLDER/$AFTER_PASS/g" "$REPORT_FILE"
sed -i "s/AFTER_FAIL_PLACEHOLDER/$AFTER_FAIL/g" "$REPORT_FILE"
sed -i "s/FIXED_PLACEHOLDER/$FIXED_COUNT/g" "$REPORT_FILE"

# Finalize detailed log with summary
log_detailed "================================================================================"
log_detailed "EXECUTION SUMMARY"
log_detailed "================================================================================"
log_detailed ""
log_detailed "Execution Completed: $EXECUTION_END"
log_detailed ""
log_detailed "OVERALL STATISTICS:"
log_detailed "  Total Rules Checked: $TOTAL_RULES"
log_detailed "  Before Audit - Passed: $BEFORE_PASS"
log_detailed "  Before Audit - Failed: $BEFORE_FAIL"
log_detailed "  Rules Remediated: $REMEDIATED_COUNT"
log_detailed "  After Audit - Passed: $AFTER_PASS"
log_detailed "  After Audit - Failed: $AFTER_FAIL"
log_detailed "  Successfully Fixed: $FIXED_COUNT"
log_detailed ""

# List failed rules after remediation
if [ "$AFTER_FAIL" -gt 0 ]; then
    log_detailed "RULES STILL FAILING AFTER REMEDIATION:"
    for rule_id in "${RULES_LIST[@]}"; do
        if [ "${AFTER_RESULTS[$rule_id]}" -ne 0 ]; then
            log_detailed "  - $rule_id (exit code: ${AFTER_RESULTS[$rule_id]})"
        fi
    done
    log_detailed ""
fi

# List successfully fixed rules
if [ "$FIXED_COUNT" -gt 0 ]; then
    log_detailed "SUCCESSFULLY FIXED RULES:"
    for rule_id in "${RULES_LIST[@]}"; do
        if [ "${BEFORE_RESULTS[$rule_id]}" -ne 0 ] && [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
            log_detailed "  - $rule_id"
        fi
    done
    log_detailed ""
fi

# List rules that passed from the start
INITIAL_PASS=0
for rule_id in "${RULES_LIST[@]}"; do
    if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ] && [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
        ((INITIAL_PASS++)) || true
    fi
done

if [ "$INITIAL_PASS" -gt 0 ]; then
    log_detailed "RULES THAT PASSED FROM THE START:"
    for rule_id in "${RULES_LIST[@]}"; do
        if [ "${BEFORE_RESULTS[$rule_id]}" -eq 0 ] && [ "${AFTER_RESULTS[$rule_id]}" -eq 0 ]; then
            log_detailed "  - $rule_id"
        fi
    done
    log_detailed ""
fi

log_detailed "================================================================================"
log_detailed "GENERATED FILES:"
log_detailed "  HTML Report: $REPORT_FILE"
log_detailed "  Detailed Log: $DETAILED_LOG"
log_detailed "================================================================================"
log_detailed ""
log_detailed "End of report."

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  Reports generated successfully!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo "Report locations:"
echo "  HTML Report:    $REPORT_FILE"
echo "  Detailed Log:   $DETAILED_LOG"
echo ""
echo "Summary:"
echo "  Before: $BEFORE_PASS passed, $BEFORE_FAIL failed"
echo "  After:  $AFTER_PASS passed, $AFTER_FAIL failed"
echo "  Fixed:  $FIXED_COUNT rule(s)"
echo ""
'''


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
    with path.open("r", encoding="utf-8") as handle:
        content = handle.read()
    
    # Remove shebang lines and normalize line endings
    lines = content.replace('\r\n', '\n').split('\n')
    filtered_lines = [line for line in lines if not line.strip().startswith('#!')]
    return '\n'.join(filtered_lines).strip()


def indent_content(content: str, spaces: int = 8) -> str:
    """Indent content by specified spaces."""
    indent = ' ' * spaces
    lines = content.split('\n')
    return '\n'.join(indent + line if line.strip() else line for line in lines)


def compose_script(registry_path: Path, rule_ids: List[str], output_path: Path) -> str:
    """Compose the full audit/remediation script."""
    registry = Registry.from_file(registry_path)
    timestamp = dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
    total = len(rule_ids)
    
    # Quoted rule IDs for bash array
    rule_ids_quoted = ' '.join(f'"{rid}"' for rid in rule_ids)
    
    # Start building script
    script_parts = [
        SCRIPT_HEADER.format(
            timestamp=timestamp,
            registry=registry_path,
            rule_count=total,
            rule_ids_quoted=rule_ids_quoted
        )
    ]
    
    # Generate audit and remediation functions for each rule
    for rule_id in rule_ids:
        entry = registry.resolve(rule_id)
        safe_id = make_safe_id(rule_id)
        
        audit_content = read_file(Path(entry["audit"]))
        remediation_content = read_file(Path(entry["remediation"]))
        
        script_parts.append(AUDIT_FUNCTION_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            audit_content=indent_content(audit_content)
        ))
        
        script_parts.append(REMEDIATION_FUNCTION_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            remediation_content=indent_content(remediation_content, 4)
        ))
    
    # Phase 1: Before audit
    for idx, rule_id in enumerate(rule_ids, 1):
        safe_id = make_safe_id(rule_id)
        script_parts.append(BEFORE_AUDIT_BLOCK.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            index=idx,
            total=total
        ))
    
    # Phase 2: Remediation
    script_parts.append(REMEDIATION_BLOCK)
    for rule_id in rule_ids:
        safe_id = make_safe_id(rule_id)
        script_parts.append(REMEDIATION_CASE_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id
        ))
    script_parts.append(REMEDIATION_BLOCK_END)
    
    # Phase 3: After audit
    script_parts.append(AFTER_AUDIT_BLOCK_HEADER)
    for idx, rule_id in enumerate(rule_ids, 1):
        safe_id = make_safe_id(rule_id)
        script_parts.append(AFTER_AUDIT_TEMPLATE.format(
            rule_id=rule_id,
            rule_id_safe=safe_id,
            index=idx,
            total=total
        ))
    
    # Phase 4: HTML report
    script_parts.append(HTML_REPORT_GENERATOR)
    
    # Join and write
    script = '\n'.join(script_parts)
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline='\n') as handle:
        handle.write(script)
    
    return script


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compose CIS audit/remediation bash script with HTML reporting"
    )
    parser.add_argument(
        "rule_ids", 
        nargs="+", 
        help="Rule IDs to include, in desired order"
    )
    parser.add_argument(
        "--registry", 
        default=Path("Rules/index.json"), 
        type=Path, 
        help="Path to registry JSON"
    )
    parser.add_argument(
        "--output", 
        default=Path("output/cis_audit.sh"), 
        type=Path, 
        help="Where to write the combined script"
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    compose_script(args.registry, args.rule_ids, args.output)
    print(f"[OK] Generated script with {len(args.rule_ids)} rule(s)")
    print(f"[OK] Output: {args.output}")
    print(f"\nTo run on target:")
    print(f"  1. Copy to target: scp {args.output} user@host:~/")
    print(f"  2. Run: sudo bash {args.output.name}")
    print(f"\nTo download reports after execution:")
    print(f"  # Find latest report:")
    print(f"  ssh user@host \"ls -d ~/cis_report_* | tail -1\"")
    print(f"  ")
    print(f"  # Download (replace user@host and timestamp):")
    print(f"  scp -r user@host:~/cis_report_YYYYMMDD_HHMMSS ~/Downloads/")


if __name__ == "__main__":
    main()
