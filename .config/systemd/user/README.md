Perfect — we can make this clean, secure, and automatic using a **user-level systemd unit** so that it mounts when *you* log in (not at boot, and no `sudo` required).

Here’s a complete, robust setup 👇

---

### 🧩 1. Create a Mount Unit

Create the following file:

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/media-erich-Rectifier.mount
```

#### **~/.config/systemd/user/media-erich-Rectifier.mount**

```ini
[Unit]
Description=Mount Rectifier CIFS share
After=network-online.target
Wants=network-online.target

[Mount]
What=//Rectifier/Media
Where=/media/erich/Rectifier
Type=cifs
Options=credentials=/home/erich/.config/credentials_Rectifier,iocharset=utf8,file_mode=0777,dir_mode=0777,uid=erich,gid=erich
TimeoutSec=30

[Install]
WantedBy=default.target
```

---

### 🧰 2. Ensure Mount Point Exists

```bash
sudo mkdir -p /media/erich/Rectifier
sudo chown erich:erich /media/erich/Rectifier
```

---

### ⚙️ 3. Enable User Systemd Session

Make sure user units are active when you log in:

```bash
sudo loginctl enable-linger erich
```

This allows your user services (like this mount) to run even without a desktop environment.

---

### 🚀 4. Enable and Start the Mount Unit

Reload your user systemd daemon and start the mount:

```bash
systemctl --user daemon-reload
systemctl --user enable --now media-erich-Rectifier.mount
```

---

### 🧩 5. Verify

Check status and mount success:

```bash
systemctl --user status media-erich-Rectifier.mount
mount | grep Rectifier
```

---

### 🧠 Notes

* The filename **must match** the mount path, replacing `/` with `-`:

  ```
  /media/erich/Rectifier → media-erich-Rectifier.mount
  ```
* `sudo` is not required because systemd mounts run as your user using the proper UID/GID options.
* The `credentials` file should look like:

  ```
  username=yourusername
  password=yourpassword
  ```

  and be set to:

  ```bash
  chmod 600 ~/.config/credentials_Rectifier
  ```

