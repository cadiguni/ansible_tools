# Ansible Tools

Repositorio para configurar uma workstation Linux com Ansible.

Objetivos:

- Configurar ambientes Linux para uso diario.
- Testar distros como CachyOS, Arch Linux, Ubuntu, Debian e Fedora.
- Instalar ferramentas de desenvolvimento, DevOps, cloud e apps graficos.
- Padronizar o ambiente com playbooks reutilizaveis.

## Distros alvo

- CachyOS / Arch Linux
- Ubuntu / Debian
- Fedora

## Estrutura

```text
.
├── ansible.cfg
├── inventory/
│   └── local.yml
├── playbooks/
│   ├── bootstrap.yml
│   └── workstation.yml
├── roles/
│   ├── common/
│   ├── dev_tools/
│   ├── docker/
│   ├── vscode/
│   └── flatpak_apps/
├── scripts/
│   └── run-local.sh
└── requirements.yml
```

Os playbooks antigos `ubuntu.yml`, `fedora.yml`, `arch_linux.yaml` e `update.yml`
foram mantidos como referencia. O fluxo principal novo fica em
`playbooks/workstation.yml`.

## Preparar a maquina

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install ansible git unzip -y
```

Arch/CachyOS:

```bash
sudo pacman -Syu ansible git unzip --needed
```

Fedora:

```bash
sudo dnf install ansible git unzip -y
```

## Executar

```bash
git clone https://github.com/lcadiguni/ansible_tools.git
cd ansible_tools
chmod +x scripts/run-local.sh
./scripts/run-local.sh
```

O script instala a collection `community.general` e roda o playbook local:

```bash
ansible-playbook -i inventory/local.yml playbooks/workstation.yml --ask-become-pass
```

Depois do role `docker`, faca logout/login para o grupo `docker` ser aplicado ao
usuario.

## Roles

- `common`: pacotes base, terminal, Python, Java 21, Flatpak e utilitarios.
- `dev_tools`: Node.js, NPM, .NET 8 onde disponivel, Azure Functions Core Tools, AWS CLI e Terraform no Arch/CachyOS.
- `docker`: Docker, Docker Compose e grupo `docker`.
- `vscode`: VS Code e extensoes principais.
- `flatpak_apps`: Firefox, OBS Studio, Audacity, Godot e Steam via Flathub.

## Tags uteis

```bash
ansible-playbook playbooks/workstation.yml --tags dev --ask-become-pass
ansible-playbook playbooks/workstation.yml --tags docker --ask-become-pass
ansible-playbook playbooks/workstation.yml --tags vscode --ask-become-pass
ansible-playbook playbooks/workstation.yml --tags media --ask-become-pass
ansible-playbook playbooks/workstation.yml --tags gaming --ask-become-pass
```

## Escopo da primeira versao

Incluido:

- Git, curl, wget, unzip, zip e 7-Zip.
- Python, Node.js/NPM, Java 21 e .NET SDK 8 onde disponivel nos repositorios da distro.
- Docker e Docker Compose.
- VS Code e extensoes.
- Firefox, OBS, Audacity, Godot e Steam via Flatpak.
- AWS CLI via pipx.
- Azure Functions Core Tools via NPM.

Ainda vale adicionar depois:

- Azure CLI.
- AWS CLI v2 por instalador oficial.
- Repositorios oficiais da Microsoft para .NET em Debian.
- Repositorio oficial da HashiCorp para Terraform em Ubuntu/Debian/Fedora.
- kubectl, Helm e k9s.
- PowerShell.
- Postman ou Insomnia.
- DaVinci Resolve.
- Heroic Games Launcher, Discord e Spotify.
