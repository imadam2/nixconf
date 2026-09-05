set shell := ["bash", "-uc"]

default:
  @just --list

gc:
  sudo nix-collect-garbage -d

clean: gc
  nix-store --optimize

up:
  nh os switch ~/nixconf

ug:
  nh os switch ~/nixconf -u

vm host:
  #!/usr/bin/env bash
  set -euo pipefail
  nixos-rebuild build-vm --flake ~/nixconf#{{host}}
  QEMU_OPTS="-m 8192M -smp 8" ./result/bin/run-*-vm

rup host:
  #!/usr/bin/env bash
  set -euo pipefail
  nh os switch ~/nixconf -H {{host}} --target-host {{host}} --ask
  ssh {{host}} 'cd ~/nixconf && git pull'

deploy host ip persist="":
  #!/usr/bin/env bash
  set -euo pipefail

  if [ "{{persist}}" = "persist" ]; then
    keydir="/tmp/{{host}}keys/persist/etc/ssh"
  else
    keydir="/tmp/{{host}}keys/etc/ssh"
  fi

  mkdir -pv "$keydir"

  if [ "{{persist}}" = "persist" ]; then
    systemd-machine-id-setup --root="/tmp/{{host}}keys/persist" --print
  fi

  ssh-keygen -t ed25519 -N "" -f "$keydir/ssh_host_ed25519_key" 
  echo ""
  echo "== Age public key for {{host}} =="
  ssh-to-age -i "$keydir/ssh_host_ed25519_key.pub"
  echo "================================="
  echo ""
  echo ">>> Add the anchor + age entry above to .sops.yaml, save, then press Enter <<<"
  read -r _
  sops updatekeys secrets/secrets.yaml
  nixos-anywhere --flake ~/nixconf#{{host}} --target-host root@{{ip}} --extra-files /tmp/{{host}}keys
