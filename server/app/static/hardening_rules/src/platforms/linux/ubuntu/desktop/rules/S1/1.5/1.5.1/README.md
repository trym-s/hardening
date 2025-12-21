# 1.5.1 Ensure address space layout randomization is enabled (Automated)

## Profile Applicability
- **Level 1** - Server
- **Level 1** - Workstation

## Description

Address space layout randomization (ASLR) is an exploit mitigation technique which randomly arranges the address space of key data areas of a process.

The `kernel.randomize_va_space` sysctl setting controls ASLR behavior:

| Value | Mode | Description |
|-------|------|-------------|
| `0` | Disabled | No randomization - addresses are static |
| `1` | Conservative | Randomize the positions of the stack, VDSO page, and shared memory regions |
| `2` | Full randomization | Randomize everything including the brk (heap) area |

> [!IMPORTANT]
> The CIS benchmark requires value `2` (full randomization) for compliance.

## Rationale

Randomly placing virtual memory regions will make it difficult to write memory page exploits as the memory placement will be consistently shifting.

ASLR makes exploitation significantly harder for attackers by:
- Preventing reliable memory address prediction
- Making return-to-libc and ROP attacks more difficult
- Increasing the difficulty of heap-based exploits

## Audit

Run `audit.sh` to verify:
- `kernel.randomize_va_space` is set to `2` in the running configuration
- The setting is correctly configured in sysctl configuration files

```bash
sudo ./audit.sh
```

### Expected Output (PASS)
```
- Audit Result: ** PASS **
 - "kernel.randomize_va_space" is correctly set to "2" in the running configuration
 - "kernel.randomize_va_space" is correctly set to "2" in "/etc/sysctl.d/60-kernel_sysctl.conf"
```

## Remediation

Run `remediation.sh` to set `kernel.randomize_va_space = 2`:

```bash
sudo ./remediation.sh
```

The script will:
1. Check the current running value
2. Add/update the setting in `/etc/sysctl.d/60-kernel_sysctl.conf`
3. Apply the setting to the running kernel
4. Verify the change was successful

### Manual Remediation

```bash
# Create configuration file
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/60-kernel_sysctl.conf

# Apply the setting
sysctl -w kernel.randomize_va_space=2
```

## Default Value

Most modern Linux distributions enable ASLR by default:

| Distribution | Default Value |
|--------------|---------------|
| Ubuntu/Debian | `2` (CIS compliant) |
| RHEL/CentOS | `2` (CIS compliant) |
| Kernel default | `2` |

---

## How the Scripts Work

### audit.sh

The audit script performs a two-part verification using the CIS benchmark's recommended approach:

**1. Running Configuration Check**
```bash
l_running_parameter_value="$(sysctl "$l_parameter_name" | awk -F= '{print $2}' | xargs)"
if grep -Pq -- '\b'"$l_parameter_value"'\b' <<< "$l_running_parameter_value"; then
    # PASS
fi
```
- Uses `sysctl` to query the current kernel parameter value
- Uses Perl-compatible regex to match the exact value `2`

**2. Persistent Configuration Check**
```bash
"$l_systemdsysctl" --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)'
```
- Uses `systemd-sysctl --cat-config` to list all sysctl configuration files
- Parses through files to find the parameter setting
- Also checks UFW's sysctl file if present

**Return Values:**
- `exit 0` (PASS) - Both running and file configurations are set to `2`
- `exit 1` (FAIL) - Either configuration is missing or not set to `2`

---

### remediation.sh

The remediation script performs four steps:

**1. Check Current Value**
```bash
CURRENT_VALUE=$(sysctl -n "$PARAM_NAME" 2>/dev/null)
```
- Shows the current running value for reference

**2. Set Durable Configuration**
```bash
if grep -q "^$PARAM_NAME" "$SYSCTL_CONF"; then
    sed -i "s/^$PARAM_NAME.*/$PARAM_NAME = $PARAM_VALUE/" "$SYSCTL_CONF"
else
    printf "%s\n" "$PARAM_NAME = $PARAM_VALUE" >> "$SYSCTL_CONF"
fi
```
- Creates or updates `/etc/sysctl.d/60-kernel_sysctl.conf`
- If parameter exists, updates it; otherwise appends it

**3. Apply to Running Kernel**
```bash
sysctl -w kernel.randomize_va_space=2
```
- Immediately applies the setting without requiring a reboot

**4. Verify**
```bash
NEW_VALUE=$(sysctl -n "$PARAM_NAME" 2>/dev/null)
```
- Confirms the new value is set correctly

---

## Configuration File Precedence

Sysctl configuration files are loaded in **lexicographical order**:
```
/etc/sysctl.conf           # Loaded first
/etc/sysctl.d/10-*.conf    # System defaults
/etc/sysctl.d/60-*.conf    # Our custom settings (loaded later, takes precedence)
/etc/sysctl.d/99-*.conf    # Highest precedence
```

---

## References

1. [Kernel Documentation - ASLR](https://www.kernel.org/doc/Documentation/sysctl/kernel.txt)
2. [PaX ASLR Documentation](https://pax.grsecurity.net/docs/aslr.txt)
3. NIST SP 800-53 Rev. 5: SI-16

## CIS Controls

| Version | Control | Description |
|---------|---------|-------------|
| v8 | 10.5 | Enable Anti-Exploitation Features |
| v7 | 8.3 | Enable Operating System Anti-Exploitation Features |

## MITRE ATT&CK Mappings

| Techniques | Tactics | Mitigations |
|------------|---------|-------------|
| T1055 (Process Injection) | TA0005 (Defense Evasion) | M1040 (Behavior Prevention on Endpoint) |
| T1203 (Exploitation for Client Execution) | TA0002 (Execution) | M1050 (Exploit Protection) |
