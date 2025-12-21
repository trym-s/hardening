# 1.5.2 Ensure ptrace_scope is restricted (Automated)

## Profile Applicability
- **Level 1** - Server
- **Level 1** - Workstation

## Description

The `ptrace()` system call provides a means by which one process (the "tracer") may observe and control the execution of another process (the "tracee"), and examine and change the tracee's memory and registers.

The `kernel.yama.ptrace_scope` sysctl setting controls the ptrace behavior:

| Value | Mode | Description |
|-------|------|-------------|
| `0` | Classic ptrace | A process can `PTRACE_ATTACH` to any other process running under the same UID |
| `1` | Restricted ptrace | A process must have a predefined relationship (parent/child) with the inferior |
| `2` | Admin-only attach | Only processes with `CAP_SYS_PTRACE` may use ptrace |
| `3` | No attach | No processes may use ptrace (irreversible until reboot) |

> [!TIP]
> **Ubuntu ships with `/etc/sysctl.d/10-ptrace.conf` which sets `kernel.yama.ptrace_scope = 1` by default. This is already CIS compliant!**

## Rationale

If one application is compromised, it would be possible for an attacker to attach to other running processes (e.g., Bash, Firefox, SSH sessions, GPG agent, etc.) to extract additional credentials and continue to expand the scope of their attack.

Enabling restricted mode will limit the ability of a compromised process to `PTRACE_ATTACH` on other processes running under the same user.

> [!IMPORTANT]
> With restricted mode, ptrace will continue to work with root user.

## Audit

Run `audit.sh` to verify:
- `kernel.yama.ptrace_scope` is set to `1`, `2`, or `3` in the running configuration
- The setting is correctly configured in sysctl configuration files (uncommented)

```bash
sudo ./audit.sh
```

### Expected Output (PASS)
```
- Audit Result: ** PASS **
 - "kernel.yama.ptrace_scope" is correctly set to "1" in the running configuration
 - "kernel.yama.ptrace_scope" is correctly set to "1" in "/etc/sysctl.d/10-ptrace.conf"
```

## Remediation

Run `remediation.sh` to set `kernel.yama.ptrace_scope = 1`:

```bash
sudo ./remediation.sh
```

The script will:
1. **Comment out** (not delete) existing entries in `/etc/sysctl.d/10-ptrace.conf` and other config files
2. Create a dedicated file `/etc/sysctl.d/60-ptrace_scope.conf` with the correct setting
3. Apply the setting to the running kernel

> [!NOTE]
> The `60-` prefix ensures our configuration is loaded **after** Ubuntu's default `10-ptrace.conf`, taking precedence.

### Manual Remediation

```bash
# Create dedicated config file
echo "kernel.yama.ptrace_scope=1" > /etc/sysctl.d/60-ptrace_scope.conf

# Apply the setting
sysctl -w kernel.yama.ptrace_scope=1
```

## Default Value

| Distribution | Default File | Default Value |
|--------------|--------------|---------------|
| Ubuntu | `/etc/sysctl.d/10-ptrace.conf` | `1` (CIS compliant) |
| Other Linux | Not set | `0` (Requires remediation) |

---

## How the Scripts Work

### audit.sh

The audit script performs a two-part verification:

**1. Running Configuration Check**
```bash
l_running_value="$(sysctl -n kernel.yama.ptrace_scope 2>/dev/null)"
if [[ "$l_running_value" =~ ^[123]$ ]]; then
    # PASS - value is 1, 2, or 3
fi
```
- Uses `sysctl -n` to query the current kernel parameter value
- Uses bash regex to validate the value is exactly `1`, `2`, or `3`

**2. Persistent Configuration Check**
```bash
for l_file in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
    # Match only UNCOMMENTED lines (no leading #)
    l_match="$(grep -E "^[^#]*kernel.yama.ptrace_scope\s*=" "$l_file")"
done
```
- Scans all sysctl configuration files
- **Skips commented lines** using pattern `^[^#]*` (lines not starting with `#`)
- Also checks UFW's sysctl file if present

**Return Values:**
- `exit 0` (PASS) - Both running and file configurations are correct
- `exit 1` (FAIL) - Either configuration is missing, commented out, or set to `0`

---

### remediation.sh

The remediation script performs three main steps:

**1. Comment Out Conflicting Entries**
```bash
for l_file in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
    # Comment out, don't delete - preserves original config
    sed -i "s/^\([^#]*kernel.yama.ptrace_scope\s*=\)/# \1/" "$l_file"
done
```
- Iterates through all sysctl configuration files
- **Comments out** (adds `#` prefix) instead of deleting entries
- Preserves original configuration for reference

**2. Create Dedicated Configuration File**
```bash
cat > /etc/sysctl.d/60-ptrace_scope.conf << EOF
kernel.yama.ptrace_scope=1
EOF
```
- Creates `/etc/sysctl.d/60-ptrace_scope.conf` (dedicated file for this setting)
- Uses `60-` prefix to load after Ubuntu's `10-ptrace.conf`
- Overwrites the file on each run to ensure correct value

**3. Apply to Running Kernel**
```bash
sysctl -w kernel.yama.ptrace_scope=1
```
- Immediately applies the setting without requiring a reboot
- The `-w` flag writes the value to the running kernel

> [!NOTE]
> The script defaults to value `1` (restricted mode). Edit `/etc/sysctl.d/60-ptrace_scope.conf` if value `2` or `3` is required by your security policy.

---

## Configuration File Precedence

Sysctl configuration files are loaded in **lexicographical order**:
```
/etc/sysctl.conf           # Loaded first
/etc/sysctl.d/10-*.conf    # Ubuntu defaults
/etc/sysctl.d/60-*.conf    # Our custom settings (loaded later, takes precedence)
/etc/sysctl.d/99-*.conf    # Highest precedence
```

If the same parameter is defined in multiple files, **the last loaded file wins**.

---

## References

1. [Kernel Documentation - Yama](https://www.kernel.org/doc/Documentation/security/Yama.txt)
2. [TermSpy - Ptrace Abuse Demo](https://github.com/raj3shp/termspy)
3. NIST SP 800-53 Rev. 5: CM-6

## CIS Controls

| Version | Control | Description |
|---------|---------|-------------|
| v8 | 4.8 | Uninstall or Disable Unnecessary Services on Enterprise Assets and Software |
| v7 | 9.2 | Ensure Only Approved Ports, Protocols and Services Are Running |

## MITRE ATT&CK Mappings

| Techniques | Tactics | Mitigations |
|------------|---------|-------------|
| T1055, T1055.008 | TA0005 (Defense Evasion) | M1040 (Behavior Prevention on Endpoint) |
