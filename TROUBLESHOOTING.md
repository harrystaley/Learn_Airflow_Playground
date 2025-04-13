# 🛠️ Troubleshooting Guide: Airflow on Podman (macOS, x86 & Apple Silicon)

This guide covers common issues and solutions when running Airflow with Podman.

---

## 🔄 Problem: Podman VM won't start

**Error:**
```
qemu exited unexpectedly with exit code -1
qemu-system-x86_64: invalid accelerator hvf
```

**Fix (Apple Silicon):**
- You're using an x86 image on ARM. Reinstall QEMU with ARM64 support:
  ```bash
  brew uninstall qemu
  /opt/homebrew/bin/brew install qemu
  ```
- Then recreate the Podman VM:
  ```bash
  podman machine rm podman-machine-default --force
  podman machine init
  podman machine start
  ```

---

## ⚠️ Problem: Airflow Web UI not accessible

**Checklist:**
- Make sure the webserver is running:
  ```bash
  podman ps
  ```
- Restart the container:
  ```bash
  podman restart airflow-webserver
  ```

**Apple Silicon + Lima users:**
- Add this to your Lima config for port forwarding:
  ```yaml
  portForwards:
    - guestPort: 8080
      hostPort: 8080
    - guestPort: 5555
      hostPort: 5555
  ```

---

## 🧩 Problem: QEMU architecture mismatch

**Check architecture:**
```bash
file $(which qemu-system-aarch64)
```

**Expected output:**
```
Mach-O 64-bit executable arm64
```

**If not:** Reinstall QEMU using the ARM-native Homebrew:
```bash
/opt/homebrew/bin/brew install qemu
```

---

## 🧪 Problem: DAGs not showing up

**Fix:**
- Make sure your DAGs are in the correct mounted volume: `dags/`
- Restart the webserver:
  ```bash
  podman restart airflow-webserver
  ```

---

## 📩 Still stuck?

Feel free to file an issue on GitHub or contact the author:

GitHub: [@harrystaley](https://github.com/harrystaley)  
LinkedIn: [linkedin.com/in/harrystaley](https://linkedin.com/in/harrystaley)
