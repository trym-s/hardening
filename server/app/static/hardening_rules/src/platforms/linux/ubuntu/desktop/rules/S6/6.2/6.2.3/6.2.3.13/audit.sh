#!/bin/bash
echo "Checking file deletion events..."
auditctl -l 2>/dev/null | grep -qE "unlink|rename|rmdir" && echo "PASS" && exit 0 || echo "FAIL" && exit 1
