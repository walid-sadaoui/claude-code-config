# Claude Code Configuration

This repository contains my personal Claude Code configurations, including custom slash commands, specialized agents, and global settings.

## Table of Contents

- [Repository Structure](#repository-structure)
- [Installation Approaches](#installation-approaches)
- [Quick Installation](#quick-installation)
- [Usage](#usage)
- [Contents](#contents)
- [Configuration Management](#configuration-management)

## Repository Structure

```
.
├── .claude/
│   ├── commands/        # Custom slash commands
│   ├── agents/          # Custom specialized agents
│   └── styles/          # Custom output styles (if configured)
├── install.sh           # Unix installation script (macOS/Linux)
├── install.ps1          # Windows installation script (PowerShell)
├── example.gitignore    # Example .gitignore for your projects
└── settings.json        # Main configuration file
```

## Installation Approaches

Claude Code supports a configuration hierarchy. Choose the approach that fits your needs:

### 1. Global Installation (Recommended for most cases)

**When to use:**
- You want the same configuration across all your projects
- You don't want to manage per-project configuration
- Simplest and most automatic solution

**Advantages:**
- ✅ No files added to your projects
- ✅ Automatically available everywhere
- ✅ Single place to maintain
- ✅ No modification of existing repositories

**Disadvantages:**
- ⚠️ Affects all projects without distinction

### 2. Per-Project Installation (For selective configuration)

**When to use:**
- You want to choose which projects use this config
- Some projects need different configurations
- You work on projects with varying requirements

**Advantages:**
- ✅ Granular control per project
- ✅ No file duplication (via symlink)
- ✅ Shared configuration with selective activation
- ✅ Compatible with local overrides

**Disadvantages:**
- ⚠️ Requires per-project installation (but automated via script)
- ⚠️ Need to add `.claude` to `.gitignore`

### 3. Hybrid Approach (Maximum flexibility)

**When to use:**
- You want a base configuration everywhere
- Some projects require specific customizations

**How it works:**
- Global installation as baseline
- Add `.claude/settings.local.json` in projects requiring overrides
- Local settings merge with / override global settings

## Quick Installation

### 1. Clone this repository

```bash
# Choose your preferred location
git clone <your-repo-url> ~/claude-code-config
cd ~/claude-code-config
```

### 2. Run the installation script

#### On Windows (PowerShell as administrator)

```powershell
# Interactive menu
.\install.ps1

# OR direct installation
.\install.ps1 -Mode global    # Global installation
.\install.ps1 -Mode project   # Current project installation
```

#### On macOS/Linux

```bash
# Interactive menu
./install.sh

# OR direct installation
./install.sh global    # Global installation
./install.sh project   # Current project installation
```

### 3. (Optional) For per-project installation

If you chose per-project installation, add `.claude` to your `.gitignore`:

```bash
# Copy the example to your project
cat example.gitignore >> .gitignore
```

## Usage

### Global installation

After global installation, your configurations are automatically available in all your projects. No additional action required.

### Per-project installation

To add the configuration to a new project:

```bash
cd /path/to/your/project
~/claude-code-config/install.sh project   # Unix
# OR
~/claude-code-config/install.ps1 -Mode project   # Windows
```

Don't forget to add `.claude` to your `.gitignore`!

### Local overrides (Hybrid approach)

To customize configuration in a specific project while keeping the global baseline:

```bash
# In your project
mkdir -p .claude
nano .claude/settings.local.json
```

Example `settings.local.json`:
```json
{
  "outputStyle": "compact",
  "hooks": {
    "preCommit": "npm test"
  }
}
```

Local settings merge with and override global settings.

## Contents

### Slash Commands

Custom slash commands are stored in `.claude/commands/`. Each `.md` file becomes a slash command.

**Example:** `.claude/commands/review.md` becomes `/review`

**Available commands:**
- `/tdd` - Uses the TDD Clean Architecture agent for test-driven development
- `/doc` - Organizes and structures notes into detailed markdown documentation

### Custom Agents

Specialized agents are defined in `.claude/agents/`. These agents have specific skills and contexts.

**Available agents:**
- `tdd-clean-architecture-expert` - Expert in Clean Architecture and TDD for Node.js/TypeScript
- `documentation-organizer` - Expert in organizing notes and writing documentation

### Output Styles

Custom styles in `.claude/styles/` define how Claude Code displays its responses (format, verbosity, etc.).

### Hooks

Hook scripts allow executing shell commands in response to events (pre-commit, post-edit, etc.). They are configured in `settings.json`.

## Configuration Management

### Update your configuration

```bash
cd ~/claude-code-config
git pull
```

Changes are immediately available (global) or at next Claude Code launch (per-project).

### Save your modifications

```bash
cd ~/claude-code-config
git add .
git commit -m "feat: add new custom command"
git push
```

### Uninstallation

#### Global installation

```bash
# Unix
rm ~/.claude

# Windows (PowerShell admin)
Remove-Item -Path "$env:USERPROFILE\.claude" -Force
```

#### Per-project installation

```bash
# In the relevant project
rm .claude
```

## Claude Code Configuration Hierarchy

Claude Code merges configurations according to this hierarchy (from highest to lowest priority):

1. **Enterprise policies** (if configured, non-modifiable)
2. **Command line arguments**
3. **Local project configuration**: `.claude/settings.local.json`
4. **Shared project configuration**: `.claude/settings.json`
5. **Global user configuration**: `~/.claude/settings.json`

More specific settings add to or override broader settings.

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Custom Commands](https://docs.claude.com/en/docs/claude-code/custom-commands)
- [Custom Agents](https://docs.claude.com/en/docs/claude-code/custom-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks)
- [Settings](https://docs.claude.com/en/docs/claude-code/settings)
