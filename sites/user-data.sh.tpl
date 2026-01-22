#!/bin/sh
set -eu

echo "=== Lightsail bootstrap starting ==="

USERNAME="curt"
USER_SHELL="/bin/bash"
TIMEZONE="America/New_York"
SSH_PUB_KEY="${PUBLIC_KEY}"

### SYSTEM UPDATE ###
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

### USER SETUP ###
if ! id "$USERNAME" >/dev/null 2>&1; then
  echo "Creating user $USERNAME"
  useradd -m -s "$USER_SHELL" "$USERNAME"
fi

# Ensure user is in groups
usermod -aG sudo,www-data "$USERNAME" || true

# SSH directory setup
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$USERNAME:$USERNAME" "$SSH_DIR"

# Add SSH key if not already present
if [ ! -f "$AUTHORIZED_KEYS" ] || ! grep -qxF "$SSH_PUB_KEY" "$AUTHORIZED_KEYS"; then
  echo "$SSH_PUB_KEY" >> "$AUTHORIZED_KEYS"
  chmod 600 "$AUTHORIZED_KEYS"
  chown "$USERNAME:$USERNAME" "$AUTHORIZED_KEYS"
fi

# Passwordless sudo
SUDO_FILE="/etc/sudoers.d/$USERNAME"
if [ ! -f "$SUDO_FILE" ]; then
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDO_FILE"
  chmod 440 "$SUDO_FILE"
fi

### PACKAGES ###
apt-get install -y nginx fail2ban

### SERVICES ###
systemctl enable nginx
systemctl enable fail2ban
systemctl restart nginx
systemctl restart fail2ban

### TIMEZONE ###
timedatectl set-timezone "$TIMEZONE"

echo "=== Lightsail bootstrap complete ==="