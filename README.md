# dev-accounts

Conta de trabalho e conta pessoal na mesma máquina Windows, sem logout/login:

- **Claude Code**: `claude` abre a conta de trabalho; `claude-personal` abre a pessoal. Os dois rodam ao mesmo tempo, um em cada terminal.
- **Git**: a identidade (nome, e-mail) e a credencial de push mudam de acordo com a pasta do repositório.
- **gh**: comandos como `gh pr` e `gh issue` usam a conta ativa. Veja a [observação sobre o gh](#observação-sobre-o-gh).

Nenhum arquivo deste repositório tem token ou senha. Os tokens ficam no keyring do Windows, guardados pelo `gh auth login`.

## Como funciona

**Claude Code** lê a configuração e o login de `~/.claude/`. Se `CLAUDE_CONFIG_DIR` apontar para outra pasta, ele usa essa pasta, com outro login. A função `claude-personal` define essa variável só durante a execução.

**Git** aplica `~/.gitconfig-personal` (via `includeIf`) a todo repositório que estiver dentro da pasta pessoal. Esse arquivo troca `user.*` e manda o credential helper pedir ao `gh` o token da conta pessoal (`gh auth token -u <usuario>`).

## Instalação

1. Logue as duas contas no gh:
   ```powershell
   gh auth login   # conta de trabalho
   gh auth login   # conta pessoal
   ```
2. Copie a função de [`powershell/profile.ps1`](powershell/profile.ps1) para o seu `$PROFILE` e abra um terminal novo.
3. Cole [`git/gitconfig.snippet`](git/gitconfig.snippet) no `~/.gitconfig`, trocando o caminho pela sua pasta pessoal. Use `/`, termine com `/`, e saiba que `gitdir/i` não diferencia maiúsculas de minúsculas.
4. Copie [`git/gitconfig-personal.template`](git/gitconfig-personal.template) para `~/.gitconfig-personal` e preencha os placeholders.
5. Rode `claude-personal` uma vez e faça login com a conta pessoal.

Para conferir, dentro de um repositório pessoal:

```powershell
git config user.email   # deve mostrar o e-mail pessoal
```

## Observação sobre o gh

O `gh` não lê o `includeIf`. Ele usa a conta ativa (`gh auth switch`), e essa escolha vale para todos os terminais. Para rodar um comando só com a conta pessoal:

```powershell
$env:GH_TOKEN = gh auth token -u <usuario-pessoal>; gh pr create
```

Outra opção é descomentar a linha `GH_TOKEN` em `claude-personal`: assim, o Claude pessoal usa a conta pessoal também no `gh`.

## Limitações

- O perfil `~/.claude-personal` começa vazio: sem plugins, skills, `settings.json` ou `CLAUDE.md` global. Copie o que quiser ou crie junctions (`New-Item -ItemType Junction`).
- Não defina `CLAUDE_CONFIG_DIR` como variável de ambiente permanente. Se fizer isso, `claude` sozinho passa a abrir o perfil dessa variável.
