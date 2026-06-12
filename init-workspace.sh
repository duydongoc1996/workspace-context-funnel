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
    # CRITICAL FIX: We append [gemini] to pull down the necessary parallel streaming handlers
    PIP_CMD="uv tool install"
    GRAPHIFY_PKG="graphifyy[gemini]"
    echo "✅ 'uv' package engine detected. Using isolated tool strings."
else
    PIP_CMD="pip install --user"
    GRAPHIFY_PKG="graphifyy[gemini]"
    echo "⚠️ 'uv' not found. Falling back to standard pip."
fi

# 2. Binary Installations
echo "📥 Ingesting static analysis core files..."
$PIP_CMD "$GRAPHIFY_PKG"
$PIP_CMD code-review-graph

if ! command -v sg &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install ast-grep
    else
        npm install -g @ast-grep/cli
    fi
fi

# 3. Structural Setup & Inline Configuration Generation
echo "📁 Configuring local workspace structural layouts..."
mkdir -p ./slack-context ./notion-context ./graphify-out ./.claude

echo "   📝 Generating CLAUDE.md priority routing documentation..."
cat << 'EOF' > ./CLAUDE.md
# Coordinated Workspace Protocol (Strict Fallback Chain)
You are working inside a multi-repo workspace structure. To maximize context efficiency, reduce token usage, and guarantee precision, you MUST resolve code search requests using this exact tools hierarchy:

## 1. Frontline Phase: code-review-graph (CRG)
- ALWAYS query CRG tools first for any codebase structure, trace, or file lookup question.
- Use `semantic_search_nodes_tool(query="...")` to look up functions or class layouts.
- Use `query_graph_tool(pattern="callers_of", target="...")` to find functional entry-points and traces.
- Use `get_impact_radius_tool(changed_files=[...])` BEFORE modifying a file to calculate cross-repository blast radiuses.

## 2. Macro Fallback Phase: Graphify
- If CRG drops 0 results or you need high-level conceptual summaries across completely distinct repositories, fall back to Graphify.
- Query via terminal execution:
  `graphify query '<search_term>' --graph graphify-out/graph.json`
- For cross-service macro call paths, run:
  `graphify path '<from_func>' '<to_func>' --graph graphify-out/graph.json`

## 3. Structural Syntax Phase: ast-grep
- If semantic graphs miss your target signature, target raw code trees natively using `ast-grep` via terminal commands:
  `sg -p 'function targetPattern($$$) { $$$ }' ./repos/`

## 4. Final Failover: ripgrep
- Only if tools 1, 2, and 3 are empty or fail to find a file pattern, fall back to a raw text sweep:
  `rg "your_search_term" ./repos`

## Multi-Repo Branching Strategy
- Individual git history exists ONLY within `./repos/*` folders. The workspace root `.` is not a git repo.
- Run git commands by navigating to the specific target folder first (e.g., `cd repos/play-engage-backend && git checkout -b feature/auth`).
EOF

echo "   📝 Generating ignore configurations..."
cat << 'EOF' > ./.graphifyignore
node_modules/
dist/
build/
.git/
graphify-out/
.code-review-graph/
slack-context/*
!slack-context/*.json
!slack-context/*.md
notion-context/*
!notion-context/*.json
!notion-context/*.md
EOF

cp ./.graphifyignore ./.code-review-graphignore

# 4. Integrate Platform Rule Configurations for Claude Code
echo "⚙️  Injecting runtime hooks into Claude Code..."
code-review-graph install --platform claude-code

# Inject local start/stop session hooks to keep code current
cat << 'EOF' > ./.claude/settings.local.json
{
  "SessionStart": [
    {
      "type": "command",
      "command": "code-review-graph build --incremental",
      "timeout": 5
    }
  ],
  "Stop": [
    {
      "type": "command",
      "command": "code-review-graph build --incremental",
      "timeout": 3
    }
  ]
}
EOF
echo "   ✅ Session hooks applied to .claude/settings.local.json"

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
