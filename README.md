# Ansible Tools

Playbooks Ansible para padronizar workstations e servidores Linux para uso
diario de desenvolvimento e DevOps.

Objetivos:

- Configurar ambientes Linux para uso diario (dev e DevOps).
- Suportar varias familias de distro com os mesmos playbooks.
- Instalar ferramentas de desenvolvimento, containers, Kubernetes, cloud e IaC.
- Manter tudo idempotente, com toggles e tags para rodar so o que interessa.

## Distros suportadas

| Familia (`ansible_os_family`) | Distros testadas / alvo              |
| ----------------------------- | ------------------------------------ |
| `Debian`                      | Ubuntu, Debian, Linux Mint, Pop!_OS   |
| `Archlinux`                   | Arch Linux, CachyOS, EndeavourOS      |
| `RedHat`                      | Fedora, RHEL, Rocky Linux, AlmaLinux  |
| `Suse`                        | openSUSE Leap/Tumbleweed, SLES        |

Familia nao suportada faz o playbook falhar cedo, com mensagem clara.

## Estrutura

```text
.
├── ansible.cfg
├── Makefile
├── inventory/
│   ├── local.yml               # workstation local
│   ├── servers.yml.example     # modelo para servidores remotos
│   └── group_vars/all.yml      # toggles e versoes
├── playbooks/
│   ├── bootstrap.yml           # instala Ansible/Git/unzip no host
│   ├── workstation.yml         # desktop dev/DevOps
│   ├── server.yml              # servidor headless + hardening
│   └── update.yml              # atualiza pacotes (multi-distro)
├── roles/
│   ├── common/                 # pacotes base e utilitarios
│   ├── shell/                  # zsh, Starship, CLI moderno, aliases
│   ├── dev_tools/              # Node, .NET, pipx, mise
│   ├── docker/                 # Docker Engine, Compose, Buildx
│   ├── kubernetes/             # kubectl, Helm, k9s, kustomize, kubectx
│   ├── cloud_tools/            # AWS CLI v2, Azure CLI, gcloud
│   ├── hashicorp/              # Terraform, Packer, Vault, TFLint
│   ├── vscode/                 # VS Code + extensoes
│   ├── flatpak_apps/           # apps graficos via Flathub
│   └── server_base/            # SSH hardening, firewall, fail2ban, NTP
├── scripts/
│   ├── run-local.sh
│   └── check.sh                # lint + dry-run
└── legacy/                     # playbooks antigos, mantidos como referencia
```

## Preparar a maquina

Ubuntu/Debian:

```bash
sudo apt update && sudo apt install ansible git unzip -y
```

Arch/CachyOS:

```bash
sudo pacman -Syu ansible git unzip --needed
```

Fedora/RHEL:

```bash
sudo dnf install ansible git unzip -y
```

openSUSE:

```bash
sudo zypper install -y ansible git unzip
```

## Executar

```bash
git clone https://github.com/cadiguni/ansible_tools.git
cd ansible_tools
./scripts/run-local.sh
```

Ou via Make:

```bash
make deps          # instala as collections
make check         # dry-run, nao altera nada
make workstation   # aplica de fato
make workstation TAGS=dev
```

Depois do role `docker` e da troca de shell, faca logout/login.

### Servidores remotos

```bash
cp inventory/servers.yml.example inventory/servers.yml
# ajuste hosts, usuario e portas liberadas
make server INVENTORY=inventory/servers.yml
```

> Antes de rodar o `server_base`, confirme que sua chave SSH ja esta no host:
> o hardening desliga login por senha e login de root.

### Atualizar pacotes

```bash
make update                                  # local
make update INVENTORY=inventory/servers.yml  # frota
```

## Roles

| Role           | O que faz                                                                   |
| -------------- | --------------------------------------------------------------------------- |
| `common`       | Pacotes base, rede, compressao, Python, Java, Flatpak, git-lfs, tmux         |
| `shell`        | zsh, Starship, fzf/ripgrep/bat/eza/zoxide/direnv e aliases de git/docker/k8s |
| `dev_tools`    | Node.js/NPM, .NET SDK, pipx (ansible-lint, pre-commit, httpie), mise         |
| `docker`       | Docker Engine pelo repo oficial, Compose v2, Buildx, daemon.json com limites de log |
| `kubernetes`   | kubectl (repo pkgs.k8s.io), Helm, k9s, kustomize, kubectx/kubens, completion |
| `cloud_tools`  | AWS CLI v2 (instalador oficial), Azure CLI (repo MS), Google Cloud CLI       |
| `hashicorp`    | Terraform, Packer e Vault pelo repo oficial; TFLint e Terragrunt opcionais   |
| `vscode`       | VS Code + extensoes (C#, Docker, Kubernetes, Ansible, Terraform, GitLens...) |
| `flatpak_apps` | OBS, Audacity, Godot, Steam, Postman e Discord via Flathub                   |
| `server_base`  | Hardening de SSH, UFW/firewalld, fail2ban, chrony, atualizacoes automaticas  |

## Toggles

Tudo em `inventory/group_vars/all.yml`. Exemplos:

```bash
# pular Kubernetes e Flatpak nesta execucao
make workstation EXTRA='-e install_kubernetes=false -e install_flatpak_apps=false'

# nao trocar o shell padrao
make workstation EXTRA='-e configure_shell=false'

# fixar a stream do repo do Kubernetes
make workstation EXTRA='-e k8s_repo_version=v1.34'
```

Versoes de binarios baixados direto do GitHub (`helm_version`, `k9s_version`,
`kustomize_version`, `kubectx_version`, `tflint_version`) tambem ficam la.
Confira a stream suportada em <https://kubernetes.io/releases/> antes de subir
a `k8s_repo_version`.

## Tags uteis

```bash
make workstation TAGS=base        # common + shell
make workstation TAGS=dev         # dev_tools + vscode
make workstation TAGS=docker
make workstation TAGS=devops      # k8s + cloud + hashicorp
make workstation TAGS=k8s
make workstation TAGS=apps        # flatpak
make server TAGS=hardening INVENTORY=inventory/servers.yml
```

## Lint e CI

```bash
make lint      # yamllint + ansible-lint
make syntax    # --syntax-check em todos os playbooks
./scripts/check.sh   # lint + dry-run com --check --diff
```

O workflow `.github/workflows/lint.yml` roda yamllint, ansible-lint e
syntax-check em cada push e pull request.

## Notas

- O Firefox foi removido da lista de Flatpaks: as distros alvo ja entregam um
  navegador e a versao do repo integra melhor com o desktop. Para reinstalar,
  adicione `org.mozilla.firefox` em `flatpak_packages`.
- Os playbooks antigos (`ubuntu.yml`, `fedora.yml`, `arch_linux.yaml`,
  `update.yml`) ficaram em `legacy/` apenas como referencia; o fluxo atual e o
  de `playbooks/`.

## Backlog

- Molecule para testar os roles em containers de cada distro.
- Role de dotfiles (git config, tmux, ssh config).
- PowerShell e DaVinci Resolve.
- Heroic Games Launcher e Spotify.
