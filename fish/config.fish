# Source the secrets file to load sensitive environment variables
source $HOME/.secrets/secrets.fish

# Set LESS environment variable to enable raw control characters
set -gx LESS '-R'

# Alias for grep with color highlighting
alias grep "grep --color=auto"

# Add common binary paths to the PATH environment variable
set -gx PATH /usr/local/bin /usr/local/sbin $PATH
set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
set -gx PATH /Users/paryan/go/bin $PATH
set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths

# Add MySQL 8.0 binary path to the PATH environment variable
set -gx PATH /opt/homebrew/opt/mysql@8.0/bin $PATH

# Set linker flags for MySQL 8.0 libraries
set -gx LDFLAGS "-L/opt/homebrew/opt/mysql@8.0/lib"

# Set preprocessor flags for MySQL 8.0 include paths
set -gx CPPFLAGS "-I/opt/homebrew/opt/mysql@8.0/include"

# Add Composer's global vendor binaries to the PATH
set -gx PATH ~/.composer/vendor/bin $PATH

# Set the default editor to Neovim
set -gx EDITOR nvim

# Set Git editor to Neovim
set -gx GIT_EDITOR nvim

# Set the Neovim listen address for remote communication
set -gx NVIM_LISTEN_ADDRESS /tmp/nvimsocket

# Set the editor for Laravel Artisan's open-on-make feature to Neovim Remote
set -gx ARTISAN_OPEN_ON_MAKE_EDITOR nvr

# Configure FZF to use The Silver Searcher (ag) for file searching
set -gx FZF_DEFAULT_COMMAND 'ag -u -g ""'

# Customize FZF UI options
set -gx FZF_DEFAULT_OPTS '
--border=rounded
--padding=0,1
--margin=4,10
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef,gutter:-1,border:#1f2335
'

# Alias for Neovim
alias vim "nvim"

# Alias for copying clipboard content using xclip
alias cpy "xclip -selection clipboard"

# Alias for pasting clipboard content using xclip
alias psta "xclip -o -selection clipboard"

# Alias for streaming webcam video using gphoto2 and ffmpeg
alias webcam "gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2"

# Alias for running Laravel Sail
alias sail '[ -f sail ] && sail || vendor/bin/sail'

# Alias for Laravel Artisan commands
alias art "php artisan"
alias tinker "art tinker"
alias seed "art db:seed"
alias serve "art serve"
alias dbprod "mysql -h prod-codd-region-nyc-mysql.internal.digitalocean.com -u usr_paryan_ro -p apps"

# Alias for modifying .env file to use SQLite as the database connection
alias sqlit "sed -e 's/\(DB_.*\)/# \\1/g' -e 's/# \(DB_CONNECTION=\).*/\\1sqlite/g' -i .env"

# Alias for running Laravel migrations with fresh seed
alias fseed "art migrate:fresh --seed"

# Function to simplify interactive Git rebase
function rebase
    if test (count $argv) -eq 0
        git rebase -i origin/master
    else
        git rebase -i origin/$argv[1]
    end
end

# Function to add files to Git staging area
function add
    if test (count $argv) -eq 0
        git add .
    else
        git add $argv
    end
end

# Alias for Git commit with a message
alias com "git commit -m"

# Alias for adding all changes and committing with a message
alias ga "git add .; git commit -m $argv"

# Alias for Git push
alias gp "git push"

# Alias for Git status
alias gs "git status"

alias clone "git clone"

# Function to create a WIP (Work In Progress) commit
function wip
    git add -A
    git commit -m "[WIP]"
end

# Function to run Git diff with additional options
function giff
    set args
    set interactive_mode 0

    for arg in $argv
        switch $arg
            case "-e"
                set interactive_mode 1
            case "--com"
                set args $args $arg
            case "--staged" "--stg" "stg"
                set args $args "--staged"
            case "--cached" "cached" "ch"
                set args $args "--cached"
            case "*"
                if test $arg != "-e"
                    set args $args $arg
                end
        end
    end

    if test $interactive_mode -eq 1
        git diff --color=always $args | less -R
    else
        git diff $args
    end
end

# Function to simplify Git branch checkout
function checkout
    if test (count $argv) -eq 0
        git checkout master
    else if test (count $argv) -eq 2 -a "$argv[2]" = "-n"
        git checkout -b $argv[1]
    else
        git checkout $argv[1]
    end
end

# Function to reset Git changes and optionally clean untracked files
function nah
    git reset --hard

    if test "$argv[1]" = "-f"
        git clean -df
    end
end

# Function to navigate to specific directories based on arguments
function cdw
    set base_path $CTHULHU_BASE_PATH

    switch $argv[1]
        case "e2e"
            cd $CTHULHU_E2E
        case "appsvc"
            cd $CTHULHU_APPSVC
        case "*"
            cd $base_path
    end
end

# Alias for Neovim
alias vi "nvim"

# Alias for listing files with eza
alias ls "eza -l $argv"

# Alias for listing files as a tree with eza
alias lss "eza -l --tree $argv"

# Alias for killing all tmux sessions
alias killmux "tmux kill-server"

# Automatically attach to tmux session if available
if type -q tmux
    and test -z "$TMUX"
        tmux attach -t default ^/dev/null; or tmux new-session -s default
end

# Alias for FZF
alias f "fzf"

# Function to manage tmux sessions
function tmx
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set items (find ~/dev -maxdepth 2 -mindepth 1 -type d)
        set items "$items\n/tmp"
        set selected (echo "$items" | fzf)
    end

    if test -z "$selected"
        return
    end

    set dirname (basename "$selected" | sed 's/\./_/g')

    tmux switch-client -t ="$dirname"
    if test $status -eq 0
        return 0
    end

    tmux new-session -c "$selected" -d -s "$dirname" && tmux switch-client -t "$dirname" || tmux new -c "$selected" -A -s "$dirname"
end

# Function to search command history using FZF
function um
    history | fzf
end

# set an alias for ssh -i ~/.ssh/thearyanahmed nine@raspberrypi.local
alias 2pi "ssh -i ~/.ssh/thearyanahmed nine@raspberrypi.local"

# Alias for printing the current directory
alias d "pwd"

# Function to find and navigate to directories using FZF
function ff
    if test (count $argv) -eq 1
        set search_dir $argv[1]
    else
        set search_dir ~/dev $HOME
    end

    set selected (find $search_dir -maxdepth 2 -mindepth 1 -type d | fzf)

    if test -n "$selected"
        cd "$selected"
    end
end

# Custom Fish shell prompt
function fish_prompt
    set_color cyan
    echo -n "prophecy"
    set_color yellow
    echo -n " >_"  # Palestine flag emoji
    set_color '#F0F8FF'
    echo -n " /"
    set_color '#ebdbb2'
    set git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_root"
        set branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            echo -n "[$branch]"
        end
    end
    echo -n " "
    set_color normal
end

# Enable vim keybindings for Fish shell
fish_vi_key_bindings


# write a function that echoss some tmux shortcuts
function tmux_shortcuts
    echo "Tmux Shortcuts:"
    echo "  Ctrl-Space c     - Create a new window"
    echo "  Ctrl-Space w     - List all windows"
    echo "  Ctrl-Space n     - Switch to the next window"
    echo "  Ctrl-Space p     - Switch to the previous window"
    echo "  Ctrl-Space d     - Detach from the current session"
    echo "  Ctrl-Space %     - Split the current pane vertically"
    echo "  Ctrl-Space \"     - Split the current pane horizontally"
    echo "  Ctrl-Space x     - Close the current pane"
    echo "  Ctrl-Space [     - Enter copy mode (scroll through history)"
    echo "  Ctrl-Space ]     - Paste copied text"
end
