# Claude Code Configuration

Ce repository contient toutes mes configurations personnalisées pour Claude Code, incluant des commandes slash personnalisées, des agents spécialisés, et des paramètres globaux.

## Table des matières

- [Structure du repository](#structure-du-repository)
- [Approches d'installation](#approches-dinstallation)
- [Installation rapide](#installation-rapide)
- [Utilisation](#utilisation)
- [Contenu](#contenu)
- [Gestion de la configuration](#gestion-de-la-configuration)

## Structure du repository

```
.
├── .claude/
│   ├── commands/        # Commandes slash personnalisées
│   ├── agents/          # Agents spécialisés personnalisés
│   └── styles/          # Styles de sortie personnalisés (si configurés)
├── install.sh           # Script d'installation Unix (macOS/Linux)
├── install.ps1          # Script d'installation Windows (PowerShell)
├── example.gitignore    # Exemple de .gitignore pour vos projets
└── settings.json        # Fichier de configuration principal
```

## Approches d'installation

Claude Code supporte une hiérarchie de configuration. Choisissez l'approche qui correspond à vos besoins :

### 1. Installation Globale (Recommandée pour la plupart des cas)

**Quand l'utiliser :**
- Vous voulez la même configuration dans tous vos projets
- Vous ne voulez pas gérer de configuration par projet
- Solution la plus simple et automatique

**Avantages :**
- ✅ Aucun fichier dans vos projets
- ✅ Automatiquement disponible partout
- ✅ Un seul endroit à maintenir
- ✅ Aucune modification des repositories existants

**Inconvénients :**
- ⚠️ Affecte tous les projets sans distinction

### 2. Installation Par Projet (Pour une configuration sélective)

**Quand l'utiliser :**
- Vous voulez choisir quels projets utilisent cette config
- Certains projets ont besoin de configurations différentes
- Vous travaillez sur des projets avec des besoins variés

**Avantages :**
- ✅ Contrôle granulaire par projet
- ✅ Pas de duplication des fichiers (via symlink)
- ✅ Configuration partagée mais activation sélective
- ✅ Compatible avec des overrides locaux

**Inconvénients :**
- ⚠️ Nécessite une installation par projet (mais automatisée via script)
- ⚠️ Besoin d'ajouter `.claude` au `.gitignore`

### 3. Approche Hybride (Maximum de flexibilité)

**Quand l'utiliser :**
- Vous voulez une configuration de base partout
- Certains projets nécessitent des customisations spécifiques

**Comment ça fonctionne :**
- Installation globale comme base
- Ajout de `.claude/settings.local.json` dans les projets qui nécessitent des overrides
- Les paramètres locaux fusionnent avec / surchargent les paramètres globaux

## Installation rapide

### 1. Cloner ce repository

```bash
# Choisissez l'emplacement de votre choix
git clone <votre-url-repo> ~/claude-code-config
cd ~/claude-code-config
```

### 2. Lancer le script d'installation

#### Sur Windows (PowerShell en mode administrateur)

```powershell
# Menu interactif
.\install.ps1

# OU installation directe
.\install.ps1 -Mode global    # Installation globale
.\install.ps1 -Mode project   # Installation pour le projet courant
```

#### Sur macOS/Linux

```bash
# Menu interactif
./install.sh

# OU installation directe
./install.sh global    # Installation globale
./install.sh project   # Installation pour le projet courant
```

### 3. (Optionnel) Pour l'installation par projet

Si vous avez choisi l'installation par projet, ajoutez `.claude` à votre `.gitignore` :

```bash
# Copier l'exemple dans votre projet
cat example.gitignore >> .gitignore
```

## Utilisation

### Installation globale

Après l'installation globale, vos configurations sont automatiquement disponibles dans tous vos projets. Aucune action supplémentaire nécessaire.

### Installation par projet

Pour ajouter la configuration à un nouveau projet :

```bash
cd /chemin/vers/votre/projet
~/claude-code-config/install.sh project   # Unix
# OU
~/claude-code-config/install.ps1 -Mode project   # Windows
```

N'oubliez pas d'ajouter `.claude` à votre `.gitignore` !

### Overrides locaux (Approche hybride)

Pour customiser la configuration dans un projet spécifique tout en conservant la base globale :

```bash
# Dans votre projet
mkdir -p .claude
nano .claude/settings.local.json
```

Exemple de `settings.local.json` :
```json
{
  "outputStyle": "compact",
  "hooks": {
    "preCommit": "npm test"
  }
}
```

Les paramètres locaux fusionnent avec et surchargent les paramètres globaux.

## Contenu

### Commandes Slash

Les commandes slash personnalisées sont stockées dans `.claude/commands/`. Chaque fichier `.md` devient une commande slash.

**Exemple :** `.claude/commands/review.md` devient `/review`

**Commandes disponibles :**
- `/tdd` - Utilise l'agent TDD Clean Architecture pour développement test-driven
- `/doc` - Organise et structure des notes en documentation markdown détaillée

### Agents Personnalisés

Les agents spécialisés sont définis dans `.claude/agents/`. Ces agents possèdent des compétences et contextes spécifiques.

**Agents disponibles :**
- `tdd-clean-architecture-expert` - Expert en Clean Architecture et TDD pour Node.js/TypeScript
- `documentation-organizer` - Expert en organisation de notes et rédaction de documentation

### Styles de Sortie

Les styles personnalisés dans `.claude/styles/` définissent comment Claude Code affiche ses réponses (format, verbosité, etc.).

### Hooks

Les scripts de hooks permettent d'exécuter des commandes shell en réponse à des événements (avant commit, après édition, etc.). Ils sont configurés dans `settings.json`.

## Gestion de la configuration

### Mettre à jour votre configuration

```bash
cd ~/claude-code-config
git pull
```

Les changements sont immédiatement disponibles (global) ou au prochain lancement de Claude Code (par projet).

### Sauvegarder vos modifications

```bash
cd ~/claude-code-config
git add .
git commit -m "feat: add new custom command"
git push
```

### Désinstallation

#### Installation globale

```bash
# Unix
rm ~/.claude

# Windows (PowerShell admin)
Remove-Item -Path "$env:USERPROFILE\.claude" -Force
```

#### Installation par projet

```bash
# Dans le projet concerné
rm .claude
```

## Hiérarchie de configuration Claude Code

Claude Code fusionne les configurations selon cette hiérarchie (du plus prioritaire au moins prioritaire) :

1. **Politiques d'entreprise** (si configurées, non modifiables)
2. **Arguments en ligne de commande**
3. **Configuration locale projet** : `.claude/settings.local.json`
4. **Configuration partagée projet** : `.claude/settings.json`
5. **Configuration utilisateur globale** : `~/.claude/settings.json`

Les paramètres plus spécifiques ajoutent ou surchargent les paramètres plus larges.

## Ressources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Custom Commands](https://docs.claude.com/en/docs/claude-code/custom-commands)
- [Custom Agents](https://docs.claude.com/en/docs/claude-code/custom-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks)
- [Settings](https://docs.claude.com/en/docs/claude-code/settings)
