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

deploy host ip:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -pv /tmp/{{host}}keys/etc/ssh
  ssh-keygen -t ed25519 -f /tmp/{{host}}keys/etc/ssh/ssh_host_ed25519 -N "" -C "{{host}}"
  echo ""
  echo "== Age public key for {{host}} =="
  ssh-to-age -i /tmp/{{host}}keys/etc/ssh/ssh_host_ed25519.pub
  echo "================================="
  echo ""
  echo ">>> Add the anchor + age entry above to .sops.yaml, save, then press Enter <<<"
  read -r _
  sops updatekeys secrets/secrets.yaml
  nixos-anywhere --flake ~/nixconf#{{host}} --target-host root@{{ip}} --extra-files /tmp/{{host}}keys
