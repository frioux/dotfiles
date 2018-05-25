# Matchmaker v0.2.1

Highlight matches for the word under the cursor.

# Usage

* `:Matchmaker` turns it on
* `:Matchmaker!` turns it off
* `:MatchmakerToggle` toggles it

**Note:** this behaviour will change in version **1.0.0**; be aware! When it
does, the new usage will look like `:Matchmaker on` / `:Matchmaker off`.
`:Matchmaker!` will toggle it. This is to make way for more commands, like
maybe `:Matchmaker someOtherMatchingMethod` to change the matching behaviour.
Also, I like it more.

# Configuration

Add `let g:matchmaker_enable_startup = 1` to your `~/.vimrc` to enable
Matchmaker when vim starts.

Add `let g:matchmaker_ignore_single_match = 1` to your `~/.vimrc` to prevent
matching when the word under the cursor doesn't show up anywhere else.

If you have any highlighting conflicts with other plugins (such as
[EasyMotion](https://github.com/Lokaltog/vim-easymotion)) you can configure
the highlighting priority with `let g:matchmaker_matchpriority = 0`, where
0 can be any value below (or above) the conflicting plugin.

# Contributing

This project uses the [git
flow](http://nvie.com/posts/a-successful-git-branching-model/) model for
development. There's [a handy git module for git
flow](//github.com/nvie/gitflow). If you'd like to be added as a contributor,
make some well-formatted pull requests (against the `develop` branch) and let
me know.

# License

Same as Vim; see `:help license`
