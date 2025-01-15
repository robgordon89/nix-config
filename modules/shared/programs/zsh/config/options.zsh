# do not beep !!!!
setopt NO_beep

# Allow comment (with '#') in zsh interactive mode
setopt interactive_comments

# Allow substitution in the prompt
setopt prompt_subst

# Accept args with ? or * in them and leave them unchanged, without erroring
# (because filename generation returns no match).
# This also applies to file expansion of an initial ‘~’ or ‘=’.
# E.g: `echo foo?bar` prints `foo?bar` or `echo ~foobar` prints `~foobar`.
setopt NO_nomatch

# Make ** an abbreviation of **/* and *** an abbreviation of ***/*
# (note: the *** variant follows symlinks)
setopt glob_star_short

# OTHERS
#-------------------------------------------------------------

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt
setopt notify

# List jobs in the long format
setopt long_list_jobs

# Don't kill background jobs on shell exit
setopt check_jobs
setopt check_running_jobs
setopt hup # Send SIGHUP to signal if we force exit

# Allow functions to have local options
setopt local_options

# Allow functions to have local traps
setopt local_traps
