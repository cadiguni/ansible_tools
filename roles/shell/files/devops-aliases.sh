# Gerenciado pelo Ansible (role: shell). Alteracoes locais serao sobrescritas.

# Git
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'
alias gp='git pull --rebase'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'
alias dprune='docker system prune -af --volumes'

# Kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs -f --tail=100'
alias kctx='kubectx'
alias kns='kubens'

# Terraform
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'

# Sistema
alias ll='ls -lah'
alias ports='ss -tulpn'
alias myip='curl -s https://ifconfig.me'

# bat/fd tem nomes diferentes no Debian/Fedora
command -v batcat >/dev/null && alias bat='batcat'
command -v fdfind >/dev/null && alias fd='fdfind'
command -v eza >/dev/null && alias ls='eza --group-directories-first'
