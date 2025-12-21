#!/usr/bin/env python3
"""Compose a custom Ansible playbook from selected CIS rule IDs.

Similar to compose_rule_scripts.py, but generates an Ansible playbook
instead of a bash script. Users can select specific rules they want to apply.

Usage:
    python3 tools/compose_ansible.py 1.5.1 1.5.2 2.1.1 --output output/custom_hardening.yml
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Dict, List


class AnsiblePlaybookComposer:
    """Composes a single Ansible playbook from selected rules."""

    def __init__(self, registry_path: Path, rule_ids: List[str], output_path: Path):
        self.registry_path = registry_path
        self.rule_ids = rule_ids
        self.output_path = output_path
        self.rules = self._load_rules()

    def _load_rules(self) -> Dict[str, Dict]:
        """Load registry and filter selected rules."""
        with self.registry_path.open('r', encoding='utf-8') as f:
            all_rules = json.load(f)

        # Create a map of rule_id -> rule_data
        rule_map = {rule['id']: rule for rule in all_rules}

        # Validate that all requested rules exist
        missing = [rid for rid in self.rule_ids if rid not in rule_map]
        if missing:
            raise ValueError(f"Rules not found in registry: {', '.join(missing)}")

        # Return ordered dict of selected rules
        return {rid: rule_map[rid] for rid in self.rule_ids}

    def _read_script(self, script_path: str) -> str:
        """Read a bash script file."""
        path = Path(script_path)
        if not path.exists():
            return ""
        with path.open('r', encoding='utf-8') as f:
            return f.read()

    def _sanitize_id(self, rule_id: str) -> str:
        """Convert rule ID to valid Ansible variable name."""
        return re.sub(r'[^a-zA-Z0-9]', '_', rule_id)

    def _extract_description(self, script_content: str) -> str:
        """Extract description from script comments."""
        lines = script_content.split('\n')
        for line in lines[1:10]:
            line = line.strip()
            if line.startswith('#') and not line.startswith('#!'):
                desc = line.lstrip('#').strip()
                if desc and not desc.startswith('==='):
                    # Clean up common patterns
                    desc = re.sub(r'^\d+\.\d+(\.\d+)* ', '', desc)
                    desc = re.sub(r'^Ensure ', '', desc)
                    desc = re.sub(r' \(Automated\)$', '', desc)
                    desc = re.sub(r' \(Manual\)$', '', desc)
                    return desc
        return "CIS Benchmark rule"

    def _create_audit_shell_command(self, script_content: str) -> str:
        """Create shell command for audit script."""
        lines = [line for line in script_content.split('\n')
                if not line.strip().startswith('#!')]
        return '\n'.join(lines).strip()

    def _create_remediation_shell_command(self, script_content: str) -> str:
        """Create shell command for remediation script.
        
        Note: Ansible shell module runs scripts in a non-function context,
        so we need to convert 'return' statements to 'exit' statements.
        """
        lines = []
        for line in script_content.split('\n'):
            stripped = line.strip()
            if stripped.startswith('#!'):
                continue
            # Keep echo statements but make them quieter
            if stripped.startswith('echo "==='):
                continue
            if stripped.startswith('echo ""'):
                continue
            # Convert return to exit for Ansible shell compatibility
            if 'return 0' in line:
                line = line.replace('return 0', 'exit 0')
            if 'return 1' in line:
                line = line.replace('return 1', 'exit 1')
            lines.append(line)
        return '\n'.join(lines).strip()

    def _indent(self, text: str, spaces: int = 4) -> str:
        """Indent text by specified spaces."""
        indent = ' ' * spaces
        lines = text.split('\n')
        return '\n'.join(indent + line if line.strip() else '' for line in lines)

    def compose_playbook(self) -> str:
        """Compose the complete Ansible playbook."""
        playbook_lines = [
            '---',
            '# Custom CIS Benchmark Hardening Playbook',
            f'# Generated from {len(self.rule_ids)} selected rules',
            '#',
            f'# Rules: {", ".join(self.rule_ids)}',
            '',
            '- name: Custom CIS Benchmark Hardening',
            '  hosts: "{{ target_hosts | default(\'all\') }}"',
            '  become: true',
            '  gather_facts: true',
            '',
            '  vars:',
            '    cis_apply_remediation: true',
            '    cis_report_dir: /tmp/cis_custom_report',
            '',
            '  pre_tasks:',
            '    - name: Create report directory',
            '      file:',
            '        path: "{{ cis_report_dir }}"',
            '        state: directory',
            '        mode: "0755"',
            '',
            '    - name: Display start message',
            '      debug:',
            f'        msg: "Starting CIS hardening for {len(self.rule_ids)} selected rules"',
            '',
            '  tasks:',
        ]

        # Generate tasks for each rule
        for idx, rule_id in enumerate(self.rule_ids, 1):
            rule = self.rules[rule_id]
            safe_id = self._sanitize_id(rule_id)

            audit_content = self._read_script(rule['audit'])
            remediation_content = self._read_script(rule['remediation'])

            if not audit_content or not remediation_content:
                print(f"[WARNING] Skipping {rule_id}: Missing audit or remediation script")
                continue

            description = self._extract_description(audit_content)

            # Add separator comment
            playbook_lines.append('')
            playbook_lines.append(f'    # ===== Rule {idx}/{len(self.rule_ids)}: {rule_id} =====')
            playbook_lines.append('')

            # Audit task
            playbook_lines.append(f'    - name: "[{idx}/{len(self.rule_ids)}] Check {rule_id}: {description}"')
            playbook_lines.append('      shell: |')
            for line in self._create_audit_shell_command(audit_content).split('\n'):
                playbook_lines.append(f'        {line}')
            playbook_lines.append(f'      register: audit_{safe_id}')
            playbook_lines.append('      failed_when: false')
            playbook_lines.append('      changed_when: false')
            playbook_lines.append('      check_mode: false')
            playbook_lines.append('')

            # Remediation task - only run if FAIL (rc == 1), skip for N/A (rc == 2)
            playbook_lines.append(f'    - name: "[{idx}/{len(self.rule_ids)}] Remediate {rule_id}: {description}"')
            playbook_lines.append('      shell: |')
            for line in self._create_remediation_shell_command(remediation_content).split('\n'):
                if line.strip():
                    playbook_lines.append(f'        {line}')
            playbook_lines.append(f'      when: audit_{safe_id}.rc == 1 and cis_apply_remediation | bool')
            playbook_lines.append(f'      register: remediate_{safe_id}')
            playbook_lines.append('      ignore_errors: true')
            playbook_lines.append('')

            # AFTER audit - re-check after remediation
            playbook_lines.append(f'    - name: "[{idx}/{len(self.rule_ids)}] Verify {rule_id} after remediation"')
            playbook_lines.append('      shell: |')
            for line in self._create_audit_shell_command(audit_content).split('\n'):
                playbook_lines.append(f'        {line}')
            playbook_lines.append(f'      register: after_audit_{safe_id}')
            playbook_lines.append('      failed_when: false')
            playbook_lines.append('      changed_when: false')
            playbook_lines.append('      check_mode: false')
            playbook_lines.append(f'      when: remediate_{safe_id} is defined and remediate_{safe_id}.changed')
            playbook_lines.append('')

            # Display result - handle PASS, FAIL, N/A, FIXED states
            playbook_lines.append(f'    - name: "[{idx}/{len(self.rule_ids)}] Display result for {rule_id}"')
            playbook_lines.append('      debug:')
            playbook_lines.append('        msg: |')
            playbook_lines.append(f'          Rule {rule_id}: {{{{ "PASS" if audit_{safe_id}.rc == 0 else "N/A" if audit_{safe_id}.rc == 2 else "FIXED" if after_audit_{safe_id} is defined and after_audit_{safe_id}.rc == 0 else "REMEDIATED (unverified)" if remediate_{safe_id} is defined and remediate_{safe_id}.changed else "FAIL" }}}}')
            playbook_lines.append('')

        # Post tasks
        playbook_lines.extend([
            '  post_tasks:',
            '    - name: Display completion message',
            '      debug:',
            f'        msg: "CIS hardening completed for {len(self.rule_ids)} rules"',
            ''
        ])

        return '\n'.join(playbook_lines)

    def generate(self):
        """Generate and write the playbook."""
        playbook_content = self.compose_playbook()

        # Ensure output directory exists
        self.output_path.parent.mkdir(parents=True, exist_ok=True)

        # Write the playbook
        with self.output_path.open('w', encoding='utf-8') as f:
            f.write(playbook_content)

        print(f"[OK] Generated Ansible playbook with {len(self.rule_ids)} rules")
        print(f"[OK] Output: {self.output_path}")
        print()
        print("To run the playbook:")
        print(f"  ansible-playbook {self.output_path}")
        print()
        print("Options:")
        print("  --check                    # Dry-run (no changes)")
        print("  -l hostname                # Run on specific host")
        print("  --extra-vars 'cis_apply_remediation=false'  # Audit only")
        print()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compose custom Ansible playbook from selected CIS rules",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Create playbook for specific rules
  python3 tools/compose_ansible.py 1.5.1 1.5.2 2.1.1 --output output/custom.yml

  # Create playbook for all Section 1 rules
  python3 tools/compose_ansible.py $(jq -r '.[] | select(.section == "Section 1 Initial Setup") | .id' Rules/index.json) --output output/section1.yml

  # Create playbook for filesystem rules
  python3 tools/compose_ansible.py 1.1.1.1 1.1.1.2 1.1.1.3 --output output/filesystem.yml
        """
    )
    parser.add_argument(
        'rule_ids',
        nargs='+',
        help='Rule IDs to include (e.g., 1.5.1 2.1.1 5.3.1.1)'
    )
    parser.add_argument(
        '--registry',
        default=Path('Rules/index.json'),
        type=Path,
        help='Path to rules registry JSON (default: Rules/index.json)'
    )
    parser.add_argument(
        '--output',
        default=Path('output/custom_cis_hardening.yml'),
        type=Path,
        help='Output playbook path (default: output/custom_cis_hardening.yml)'
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if not args.registry.exists():
        print(f"[ERROR] Registry not found: {args.registry}")
        print("Please run: python3 tools/build_registry.py")
        return

    try:
        composer = AnsiblePlaybookComposer(args.registry, args.rule_ids, args.output)
        composer.generate()
    except ValueError as e:
        print(f"[ERROR] {e}")
        return


if __name__ == '__main__':
    main()
