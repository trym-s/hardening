#!/bin/bash

# 6.3.1 - AIDE installed
cat > 6.3.1/audit.sh << 'EOF'
#!/bin/bash
echo "Checking if AIDE is installed..."
if dpkg-query -s aide aide-common &>/dev/null; then
    echo "PASS: AIDE is installed"
    dpkg-query -W aide aide-common
    exit 0
else
    echo "FAIL: AIDE is not installed"
    exit 1
fi
EOF

cat > 6.3.1/remediation.sh << 'EOF'
#!/bin/bash
echo "Installing AIDE..."
apt-get update
apt-get install -y aide aide-common
echo "Initializing AIDE database (this may take a while)..."
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
echo "AIDE has been installed and initialized"
EOF

# 6.3.2 - Filesystem integrity check
cat > 6.3.2/audit.sh << 'EOF'
#!/bin/bash
echo "Checking if filesystem integrity check is scheduled..."
if crontab -l 2>/dev/null | grep -q "aide" || \
   grep -r "aide" /etc/cron.* /etc/crontab 2>/dev/null | grep -v "^#"; then
    echo "PASS: AIDE is scheduled"
    exit 0
else
    echo "FAIL: AIDE integrity check is not scheduled"
    exit 1
fi
EOF

cat > 6.3.2/remediation.sh << 'EOF'
#!/bin/bash
echo "Scheduling AIDE filesystem integrity check..."
cat > /etc/cron.daily/aide << 'CRON'
#!/bin/bash
/usr/bin/aide --check
CRON
chmod +x /etc/cron.daily/aide
echo "AIDE has been scheduled to run daily"
EOF

# 6.3.3 - Cryptographic mechanisms
cat > 6.3.3/audit.sh << 'EOF'
#!/bin/bash
echo "Checking cryptographic integrity for audit tools..."
if grep -rE "^/usr/sbin/(auditctl|auditd|ausearch|aureport|autrace|augenrules)" /etc/aide/aide.conf* 2>/dev/null; then
    echo "PASS: Audit tools are protected by AIDE"
    exit 0
else
    echo "FAIL: Audit tools are not configured in AIDE"
    exit 1
fi
EOF

cat > 6.3.3/remediation.sh << 'EOF'
#!/bin/bash
echo "Adding audit tools to AIDE configuration..."
cat >> /etc/aide/aide.conf << 'CONF'
# Audit tools
/usr/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512
/usr/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512
/usr/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512
/usr/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512
/usr/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512
/usr/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512
CONF
echo "Updating AIDE database..."
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
echo "Audit tools have been added to AIDE"
EOF

# Make all executable
find . -name "*.sh" -exec chmod +x {} \;
echo "Created all 6.3 files"
