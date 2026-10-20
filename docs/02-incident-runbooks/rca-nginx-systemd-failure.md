# Incident Report & RCA: Nginx Service Startup Failure

**Incident ID:** INC-20261020-01  
**Severity:** P1 (Production Web Service Down)  
**Status:** Resolved  
**Investigator:** Darshan Nair  

---

## 1. Incident Summary
Following a configuration deployment, the `nginx.service` failed to restart via `systemd`, resulting in complete HTTP traffic unavailability on port 80.

---

## 2. Root Cause Analysis (RCA)
* **Immediate Cause:** A malformed configuration directive (`broken_directive_test;`) was injected at line 1 of `/etc/nginx/nginx.conf`.
* **System Behavior:** `systemd` executed `ExecStartPre=/usr/sbin/nginx -t -q`, which detected the syntax violation, exited with status code `code=exited, status=1/FAILURE`, and aborted the `ExecStart` process.

---

## 3. Diagnostic Workflow
1. Checked service status:
   ```bash
   sudo systemctl status nginx --no-pager