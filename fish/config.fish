# This configuration file is for the Fish shell and contains various environment variable settings, aliases, and functions.

# PATH Configuration:
# - Adds `/usr/local/bin`, `/usr/local/sbin`, `/opt/homebrew/bin`, `/opt/homebrew/sbin`, and MySQL 8.0 binary paths to the PATH environment variable.
# - Ensures Composer's global vendor binaries are included in the PATH.

# MySQL 8.0 Configuration:
# - Sets linker flags (LDFLAGS) to include MySQL 8.0 library paths.
# - Sets preprocessor flags (CPPFLAGS) to include MySQL 8.0 include paths.

# Editor Configuration:
# - Sets the default editor to `nvim` (Neovim).
# - Configures Git to use `nvim` as its editor.
# - Sets the Neovim listen address for remote communication via `/tmp/nvimsocket`.
# - Configures Artisan to use `nvr` (Neovim Remote) as the editor for the `open-on-make` feature.

# FZF Configuration:
# - Sets the default FZF command to use `ag` (The Silver Searcher) for file searching.
# - Customizes FZF UI options, including border style, padding, margin, and color scheme.

# Aliases:
# - `vim`: Alias for `nvim`.
# - `cpy`: Copies clipboard content using `xclip`.
# - `psta`: Pastes clipboard content using `xclip`.
# - `webcam`: Streams webcam video using `gphoto2` and `ffmpeg`.
# - `sail`: Runs Laravel Sail if the `sail` file exists, otherwise defaults to `vendor/bin/sail`.
# - `art`: Shortcut for `php artisan`.
# - `tinker`: Shortcut for `php artisan tinker`.
# - `seed`: Shortcut for `php artisan db:seed`.
# - `serve`: Shortcut for `php artisan serve`.
# - `sqlit`: Modifies `.env` file to use SQLite as the database connection.
# - `fseed`: Shortcut for `php artisan migrate:fresh --seed`.

# Function:
# - `rebase`: Simplifies the process of performing an interactive Git rebase.
#   - Usage:
#     - `rebase`: Rebases the current branch interactively onto `origin/master`.
#     - `rebase <branch>`: Rebases the current branch interactively onto `origin/<branch>`.
#   - Notes:
#     - Assumes the use of the Fish shell.
#     - Requires the target branch to exist in the `origin` remote.
set -gx PATH /usr/local/bin /usr/local/sbin $PATH
set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH

# Export MySQL 8.0 paths
set -gx PATH /opt/homebrew/opt/mysql@8.0/bin $PATH
set -gx LDFLAGS "-L/opt/homebrew/opt/mysql@8.0/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/mysql@8.0/include"

# Export Composer vendor bin
set -gx PATH ~/.composer/vendor/bin $PATH

# Set the default editor to nvim
set -gx EDITOR nvim

# Set Git editor to nvim
set -gx GIT_EDITOR nvim

# Set the Neovim listen address for remote communication
set -gx NVIM_LISTEN_ADDRESS /tmp/nvimsocket

# Set the editor for Artisan to nvr (Neovim Remote)
set -gx ARTISAN_OPEN_ON_MAKE_EDITOR nvr

# Set default FZF command to use ag (The Silver Searcher)
set -gx FZF_DEFAULT_COMMAND 'ag -u -g ""'

# Set FZF options for UI customization
set -gx FZF_DEFAULT_OPTS '
--border=rounded
--padding=0,1
--margin=4,10
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef,gutter:-1,border:#1f2335
'

alias vim "nvim"
alias cpy "xclip -selection clipboard"
alias psta "xclip -o -selection clipboard"
alias webcam "gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2"
alias sail '[ -f sail ] && sail || vendor/bin/sail'

alias art "php artisan"
alias tinker "art tinker"
alias seed "art db:seed"
alias serve "art serve"
alias sqlit "sed -e 's/\(DB_.*\)/# \\1/g' -e 's/# \(DB_CONNECTION=\).*/\\1sqlite/g' -i .env"
alias fseed "art migrate:fresh --seed"
# This function, `rebase`, simplifies the process of performing an interactive git rebase.
# Usage:
#   rebase            - Rebases the current branch interactively onto `origin/master`.
#   rebase <branch>   - Rebases the current branch interactively onto `origin/<branch>`.
# Arguments:
#   <branch> (optional) - The name of the branch to rebase onto. If not provided, defaults to `master`.
# Notes:
#   - This function assumes you are using `fish` shell.
#   - Ensure that the branch you are rebasing onto exists in the `origin` remote.
function rebase
    if test (count $argv) -eq 0
        git rebase -i origin/master
    else
        git rebase -i origin/$argv[1]
    end
end

alias add "git add"
alias commit "git commit -m"
alias com "git commit -m"
alias gp "git push"
alias gs "git status"
function wip
    git add -A
    git commit -m "[WIP]"
end
# The `giff` function is a custom Fish shell function for running `git diff` with additional options.
# It supports both interactive and non-interactive modes.
#
# Usage:
#   giff [OPTIONS] [ARGS]
#
# Options:
#   -e              Enable interactive mode. Displays the diff output in a pager (`less`) with color.
#   --com           Passes the `--com` argument to `git diff`.
#   --staged        Passes the `--staged` argument to `git diff`.
#   --cached        Passes the `--cached` argument to `git diff`.
#
# Arguments:
#   Any additional arguments are passed directly to the `git diff` command.
#
# Examples:
#   giff --staged
#       Runs `git diff --staged`.
#
#   giff -e --cached
#       Runs `git diff --cached` in interactive mode with colored output.
#
# Notes:
#   - Interactive mode (`-e`) uses `less -R` to display the output with color.
#   - If `-e` is not specified, the output is printed directly to the terminal.
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

# This function simplifies the process of checking out Git branches.
# Usage:
#   checkout                - Checks out the "master" branch.
#   checkout <branch>       - Checks out the specified branch.
#   checkout <branch> -n    - Creates and checks out a new branch with the specified name.
# Arguments:
#   <branch> - The name of the branch to checkout or create.
#   -n       - Optional flag to create a new branch.
# Notes:
#   - If no arguments are provided, the function defaults to checking out the "master" branch.
#   - If two arguments are provided and the second argument is "-n", a new branch is created.
function checkout
    if test (count $argv) -eq 0
        git checkout master
    else if test (count $argv) -eq 2 -a "$argv[2]" = "-n"
        git checkout -b $argv[1]
    else
        git checkout $argv[1]
    end
end
