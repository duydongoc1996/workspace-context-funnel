# workspace-context-funnel
A 1-click bootstrap script to chain code-review-graph, Graphify, and ast-grep into a token-efficient local stack for Claude Code


```bash
./
├── templates/
│   ├── CLAUDE.md                 # The strict priority-chain developer rules
│   ├── .graphifyignore           # Scoping filters for Graphify
│   ├── .code-review-graphignore  # Scoping filters for CRG
│   └── settings.template.json    # Local session start/stop hooks template
└── init-workspace.sh             # ◄ The 1-Hit Setup Script

```
