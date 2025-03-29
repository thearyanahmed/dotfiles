# dotfiles
Home sweet home


## Private file
The private file is source controlled only for the keys, but the values will be stripped away. So,
```
# Private file
SECRET_API_KEY="don't share the password"
```

Will become
```
# Private file
SECRET_API_KEY=""
```
Checkout `git/hooks/pre-commit` for the source code. If you wish to use it, in your local repo, put the file to
`.git/hooks/pre-commit`

## Tmux
Tmux prefix key `CTRL+space`, which I'll refer as Leader or L. And these + keys are kinda like L then let go, then secondary keys.
0. New window L+c
1. Next window: L+n
2. Previous: L+p
3. L% is quivalent to vsp
4. L" is quivalent to sp
5. L+: new-session -s $name
6. L+s: List all the sesions
7. L+~(h|j|k|l) to switch between panes
8. L+x to close pane
9. L+, to rename a window
10. L+$ to rename session

### man tmux

The default command key bindings are:

C-b         Send the prefix key (C-b) through to the application.
C-o         Rotate the panes in the current window forwards.
C-z         Suspend the tmux client.
!           Break the current pane out of the window.
"           Split the current pane into two, top and bottom.
#           List all paste buffers.
$           Rename the current session.
%           Split the current pane into two, left and right.
&           Kill the current window.
'           Prompt for a window index to select.
(           Switch the attached client to the previous session.
)           Switch the attached client to the next session.
,           Rename the current window.
-           Delete the most recently copied buffer of text.
           .           Prompt for an index to move the current window.
           0 to 9      Select windows 0 to 9.
           :           Enter the tmux command prompt.
           ;           Move to the previously active pane.
           =           Choose which buffer to paste interactively from a list.
           ?           List all key bindings.
           D           Choose a client to detach.
           L           Switch the attached client back to the last session.
           [           Enter copy mode to copy text or view the history.
           ]           Paste the most recently copied buffer of text.
           c           Create a new window.
           d           Detach the current client.
           f           Prompt to search for text in open windows.
           i           Display some information about the current window.
           l           Move to the previously selected window.
           m           Mark the current pane (see select-pane -m).
           M           Clear the marked pane.
           n           Change to the next window.
           o           Select the next pane in the current window.
           p           Change to the previous window.
           q           Briefly display pane indexes.
           r           Force redraw of the attached client.
           s           Select a new session for the attached client interactively.
           t           Show the time.
           w           Choose the current window interactively.
           x           Kill the current pane.
           z           Toggle zoom state of the current pane.
           {           Swap the current pane with the previous pane.
           }           Swap the current pane with the next pane.
           ~           Show previous messages from tmux, if any.
           Page Up     Enter copy mode and scroll one page up.
           Up, Down
           Left, Right
                       Change to the pane above, below, to the left, or to the right of the current pane.
           M-1 to M-5  Arrange panes in one of the seven preset layouts: even-horizontal, even-vertical, main-horizontal, main-horizontal-mirrored, main-vertical, main-vertical, or tiled.
           Space       Arrange the current window in the next preset layout.
           M-n         Move to the next window with a bell or activity marker.
           M-o         Rotate the panes in the current window backwards.
           M-p         Move to the previous window with a bell or activity marker.
           C-Up, C-Down
           C-Left, C-Right
                       Resize the current pane in steps of one cell.
           M-Up, M-Down
           M-Left, M-Right
                       Resize the current pane in steps of five cells.


## CoC rust
```txt

  // Enable the rust-analyzer extension
  "rust-analyzer.enable": true,
  // Don't emit #[must_use] when generating code - power users typically know when to add this themselves
  "rust-analyzer.assist.emitMustUse": false,
  // Use unimplemented!() instead of todo!() for fill expressions - better for production code
  "rust-analyzer.assist.expressionFillDefault": "unimplemented",
  // Enable cache priming for faster startup after initial load
  "rust-analyzer.cachePriming.enable": true,
  "rust-analyzer.cachePriming.numThreads": 0, // Auto-detect number of threads
  // Essential cargo settings for power users
  "rust-analyzer.cargo.autoreload": true,
  "rust-analyzer.cargo.buildScripts.enable": true,
  "rust-analyzer.cargo.buildScripts.invocationLocation": "workspace",
  "rust-analyzer.cargo.buildScripts.invocationStrategy": "per_workspace", // More efficient for large projects
  "rust-analyzer.cargo.buildScripts.useRustcWrapper": true,
  // Uncomment and customize if you use specific features often
  // "rust-analyzer.cargo.features": "your-common-features",
  "rust-analyzer.cargo.noDefaultFeatures": false,
  "rust-analyzer.cargo.sysroot": "discover",
  // Enhanced checking settings for power users
  "rust-analyzer.check.allTargets": true,
  "rust-analyzer.check.command": "clippy", // Use clippy instead of check for better lints
  "rust-analyzer.check.extraArgs": [
    "--",
    "-W",
    "clippy::all",
    "-W",
    "clippy::pedantic"
  ], // Strict linting
  "rust-analyzer.check.invocationStrategy": "per_workspace", // Faster for large workspaces
  "rust-analyzer.checkOnSave": true,
  // Smart completion settings
  "rust-analyzer.completion.autoimport.enable": true,
  "rust-analyzer.completion.autoself.enable": true,
  "rust-analyzer.completion.callable.snippets": "fill_arguments",
  "rust-analyzer.completion.limit": 200, // Higher limit for more options
  "rust-analyzer.completion.postfix.enable": true,
  // Enable editing private fields from test modules
  "rust-analyzer.completion.privateEditable.enable": true,
  // Diagnostics tuning
  "rust-analyzer.diagnostics.enable": true,
  "rust-analyzer.diagnostics.experimental.enable": true, // Power users can handle experimental features
  // Add specific warning codes you often want to treat differently, e.g.:
  // "rust-analyzer.diagnostics.warningsAsInfo": ["unused_variables"],
  // Performance optimization
  "rust-analyzer.files.excludeDirs": [
    "target",
    ".git",
    "node_modules",
    "dist"
  ],
  "rust-analyzer.files.watcher": "client",
  // Enhanced code highlighting
  "rust-analyzer.highlightRelated.breakPoints.enable": true,
  "rust-analyzer.highlightRelated.exitPoints.enable": true,
  "rust-analyzer.highlightRelated.references.enable": true,
  "rust-analyzer.highlightRelated.yieldPoints.enable": true, // Useful for async code
  // Hover settings
  "rust-analyzer.hover.documentation.enable": true,
  "rust-analyzer.hover.documentation.keywords.enable": true,
  "rust-analyzer.hover.links.enable": true,
  // Import organization for clean code
  "rust-analyzer.imports.granularity.enforce": true, // Enforce consistent style
  "rust-analyzer.imports.granularity.group": "module", // More specific than crate for power users
  "rust-analyzer.imports.group.enable": true,
  "rust-analyzer.imports.merge.glob": true,
  "rust-analyzer.imports.prefix": "crate", // More idiomatic Rust
  // Inlay hints - carefully tuned for power users
  "rust-analyzer.inlayHints.bindingModeHints.enable": false, // Experienced users recognize bindings
  "rust-analyzer.inlayHints.chainingHints.enable": true,
  "rust-analyzer.inlayHints.closingBraceHints.enable": true,
  "rust-analyzer.inlayHints.closingBraceHints.minLines": 15, // Lower threshold for large files
  "rust-analyzer.inlayHints.closureReturnTypeHints.enable": "with_block", // Show for multi-line closures
  "rust-analyzer.inlayHints.discriminantHints.enable": "fieldless", // Helpful for C-like enums
  "rust-analyzer.inlayHints.expressionAdjustmentHints.enable": "always", // Helpful for ref/deref clarity
  "rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe": false,
  "rust-analyzer.inlayHints.lifetimeElisionHints.enable": "skip_trivial", // Show non-obvious lifetime elisions
  "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames": true,
  "rust-analyzer.inlayHints.maxLength": 50, // Longer hints for power users who can parse them
  "rust-analyzer.inlayHints.parameterHints.enable": true,
  "rust-analyzer.inlayHints.reborrowHints.enable": "mutable", // Show mutable reborrows which are easy to miss
  "rust-analyzer.inlayHints.typeHints.enable": true,
  "rust-analyzer.inlayHints.typeHints.hideClosureInitialization": false,
  "rust-analyzer.inlayHints.typeHints.hideNamedConstructor": false,
  // Code actions
  "rust-analyzer.joinLines.joinAssignments": true,
  "rust-analyzer.joinLines.joinElseIf": true,
  "rust-analyzer.joinLines.removeTrailingComma": true,
  "rust-analyzer.joinLines.unwrapTrivialBlock": true,
  // Code lenses for quick access to run/debug/implementations
  "rust-analyzer.lens.debug.enable": true,
  "rust-analyzer.lens.enable": true,
  "rust-analyzer.lens.forceCustomCommands": true,
  "rust-analyzer.lens.implementations.enable": true,
  "rust-analyzer.lens.location": "above_name",
  // Turn these on if you need to frequently check references
  "rust-analyzer.lens.references.adt.enable": true,
  "rust-analyzer.lens.references.enumVariant.enable": true,
  "rust-analyzer.lens.references.method.enable": true,
  // Adjust manually if you have large macro-heavy projects
  // "rust-analyzer.procMacro.enable": true,
  // "rust-analyzer.procMacro.attributes.enable": true
```
