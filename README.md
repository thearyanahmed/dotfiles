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
