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
