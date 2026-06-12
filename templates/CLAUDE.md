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
