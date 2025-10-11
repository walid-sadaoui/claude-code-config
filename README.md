# Claude Code Configuration

Ce repository contient toutes mes configurations personnalisées pour Claude Code.

## Structure

```
.
├── .claude/
│   ├── commands/     # Commandes slash personnalisées
│   └── styles/       # Styles de sortie personnalisés
├── hooks/            # Scripts de hooks personnalisés
└── settings.json     # Fichier de configuration principal
```

## Installation

### 1. Cloner ce repository

```bash
git clone <votre-url-repo> ~/claude-code-config
```

### 2. Créer des liens symboliques

#### Sur Windows (PowerShell en mode administrateur)

```powershell
# Lien vers le dossier .claude
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\.claude" -Target "$HOME\claude-code-config\.claude"

# Lien vers settings.json
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Claude Code\User\settings.json" -Target "$HOME\claude-code-config\settings.json"
```

#### Sur macOS/Linux

```bash
# Lien vers le dossier .claude
ln -s ~/claude-code-config/.claude ~/.claude

# Lien vers settings.json
ln -s ~/claude-code-config/settings.json ~/Library/Application\ Support/Claude\ Code/User/settings.json
```

## Contenu

### Commandes Slash

Les commandes slash personnalisées sont stockées dans `.claude/commands/`. Chaque fichier `.md` devient une commande.

Exemple : `.claude/commands/review.md` devient `/review`

### Styles de Sortie

Les styles personnalisés sont dans `.claude/styles/`. Ces styles définissent comment Claude Code affiche ses réponses.

### Hooks

Les scripts de hooks permettent d'exécuter des commandes shell en réponse à des événements. Ils sont configurés dans `settings.json`.

## Utilisation

Après l'installation, toutes vos configurations seront synchronisées via Git. Pour mettre à jour :

```bash
cd ~/claude-code-config
git pull
```

Pour sauvegarder vos modifications :

```bash
cd ~/claude-code-config
git add .
git commit -m "Update configurations"
git push
```

## Documentation

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Custom Commands](https://docs.claude.com/en/docs/claude-code/custom-commands)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks)
- [Output Styles](https://docs.claude.com/en/docs/claude-code/output-styles)
