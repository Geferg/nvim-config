No abstraction of single line logic. No exceptions™

Try to follow binds as:
- `group-key`
    - `repeat-group-key` for main functionality
    - `variation-key` for group-specific behavior

Commit message prefixes can be:
- feat
- fix
- chore
- docs
- style
- refactor
- perf
- build
- revert

`cwd` is used only for *hard-modifying* operations (e.g. creating/deleting files, generating scaffolding).

`project_root` is used for *soft-modifying* logic (e.g. generating compile files, running analysis).
