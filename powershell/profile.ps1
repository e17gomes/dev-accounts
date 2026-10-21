# Claude Code com a conta pessoal; `claude` sozinho continua na conta de trabalho (~/.claude)
function claude-personal {
  $env:CLAUDE_CONFIG_DIR = "$HOME\.claude-personal"
  # Opcional: gh também na conta pessoal dentro desta sessão
  # $env:GH_TOKEN = gh auth token -u <usuario-pessoal>
  try { claude @args } finally { Remove-Item Env:CLAUDE_CONFIG_DIR, Env:GH_TOKEN -ErrorAction SilentlyContinue }
}
