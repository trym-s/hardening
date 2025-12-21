# 5.2.7 Ensure access to the su command is restricted (Automated)

**Profile Applicability:**
- Level 1 - Server
- Level 1 - Workstation

## Description
The `su` command allows a user to run a command or shell as another user. Access to the `su` command can be restricted.

## Rationale
Restricting the use of `su` to a named group provides system administrators better control of the escalation of user privileges.

## Audit
```bash
grep -Pi -- '^\h*auth\h+\H+\h+pam_wheel\.so\h+' /etc/pam.d/su
```
Verify output includes `use_uid` and `group=` settings.

## Remediation
```bash
# Create empty sugroup if it doesn't exist
groupadd sugroup

# Configure PAM to restrict su to sugroup members
sed -i '/pam_wheel.so/d' /etc/pam.d/su
echo "auth required pam_wheel.so use_uid group=sugroup" >> /etc/pam.d/su
```

## References
- NIST SP 800-53 Rev. 5: AC-6
