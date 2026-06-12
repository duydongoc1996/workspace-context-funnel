#!/usr/bin/env bash

# Exit immediately if any command returns a non-zero status
set -e

echo "🚀 Bootstrapping Combined High-Performance AI Pipeline..."
echo "=================================================================="

# 1. Verify Node and Package Manager status
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is required but missing from your system."
    exit 1
fi

if command -v uv &> /dev/null; then
    PIP_CMD="uv tool install"
    echo "✅ 'uv' package engine detected. Using isolated tool strings."
else
    PIP_CMD="pip install --user"
    echo "⚠️ 'uv' not found. Falling back to standard pip."
fi

# 2. Binary Installations
echo "📥 Ingesting static analysis core files..."
$PIP_CMD graphifyy
$PIP_CMD code-review-graph

if ! command -v sg &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install ast-grep
    else
        npm install -g @ast-grep/cli
    fi
fi

# 3. Structural Setup
echo "📁 Configuring local workspace structural layouts..."
mkdir -p ./slack-context ./notion-context ./graphify-out ./.claude

# Move core templates into operation positions
cp ./templates/CLAUDE.md ./CLAUDE.md
cp ./templates/.graphifyignore ./.graphifyignore
cp ./templates/.code-review-graphignore ./.code-review-graphignore

# 4. Integrate Platform Rule Configurations for Claude Code
echo "⚙️  Injecting runtime hooks into Claude Code..."
code-review-graph install --platform claude-code

# Merge the local start/stop session hooks to keep code current
if [ -f "./templates/settings.template.json" ]; then
    cp ./templates/settings.template.json ./.claude/settings.local.json
    echo "   ✅ Session hooks applied to .claude/settings.local.json"
fi

# 5. Iterative Sub-Repository Hook Attachment
REPOS_DIR="./repos"
if [ -d "$REPOS_DIR" ]; then
    echo "🪝 Attaching automated Git hooks to independent sub-repositories..."
    for repo in "$REPOS_DIR"/*; do
        if [ -d "$repo" ] && [ -d "$repo/.git" ]; then
            repo_name=$(basename "$repo")
            echo "   -> Injecting hooks into: $repo_name"
            # Installs graphify's incremental commit/checkout trackers
            (cd "$repo" && graphify hook install)
        fi
    done
else
    echo "ℹ️  No './repos' directory found. Skipping sub-repository loop."
fi

# 6. Global First Compilation Pass
echo "------------------------------------------------------------------"
echo "🧠 Executing first-pass graph compilations..."

echo "   ⚡ Compiling code-review-graph database..."
code-review-graph build

echo "   ⚡ Compiling macro Graphify context topology map..."
graphify . -o ./graphify-out

echo "=================================================================="
echo "🎉 SUCCESS! Your combined engine pipeline is active and configured."
echo "👉 Simply type 'claude' from this root folder to start working!"
