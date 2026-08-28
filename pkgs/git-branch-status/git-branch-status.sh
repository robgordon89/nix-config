#!/usr/bin/env bash
#
# git-branch-status — show which branch each repo is on vs its default branch.
# Lives on PATH as `git-branch-status`, so git exposes it as `git branch-status`.

set -uo pipefail

usage() {
  cat <<'EOF'
git-branch-status — show which branch each repo is on vs its default branch.

Usage:
  git branch-status [options] [dir ...]

Options:
  -d, --depth N       how deep to look for repos under each dir (default 1)
  -a, --ahead-behind  also show ahead/behind counts vs the tracking branch
  -m, --mismatch      only list repos not on their default branch
  -f, --fix-head      set origin/HEAD from the remote when it's missing
                      (does network I/O)
  -C, --no-color      plain output
  -h, --help          this text

Default branch is resolved locally, in order:
  1. refs/remotes/origin/HEAD
  2. first of origin/{main,master,trunk,develop} that exists
  3. init.defaultBranch, else "?"

Exit status is 1 if any repo is off its default branch, 0 otherwise.
EOF
}

depth=1
show_ahead=0
only_mismatch=0
fix_head=0
color=auto
roots=()

die() { printf '%s: %s\n' "${0##*/}" "$1" >&2; exit 2; }

while (($#)); do
  case "$1" in
    -d|--depth)        depth="${2:-}"; [[ $depth =~ ^[0-9]+$ ]] || die "--depth needs a number"; shift 2 ;;
    -a|--ahead-behind) show_ahead=1; shift ;;
    -m|--mismatch)     only_mismatch=1; shift ;;
    -f|--fix-head)     fix_head=1; shift ;;
    -C|--no-color)     color=never; shift ;;
    -h|--help)         usage; exit 0 ;;
    --)                shift; roots+=("$@"); break ;;
    -*)                die "unknown option: $1" ;;
    *)                 roots+=("$1"); shift ;;
  esac
done

((${#roots[@]})) || roots=(.)

if [[ $color == auto ]]; then
  [[ -t 1 ]] && color=always || color=never
fi
if [[ $color == always ]]; then
  bold=$'\e[1m'; green=$'\e[32m'; yellow=$'\e[33m'; red=$'\e[31m'; dim=$'\e[2m'; reset=$'\e[0m'
else
  bold=''; green=''; yellow=''; red=''; dim=''; reset=''
fi

# --- collect repos -----------------------------------------------------------

repos=()
for root in "${roots[@]}"; do
  [[ -d $root ]] || { printf '%s: not a directory: %s\n' "${0##*/}" "$root" >&2; continue; }
  if [[ -e $root/.git ]]; then
    repos+=("${root%/}")
    continue
  fi
  while IFS= read -r gitdir; do
    repos+=("$(dirname "$gitdir")")
  done < <(find "$root" -mindepth 2 -maxdepth "$((depth + 1))" -name .git -print 2>/dev/null | sort)
done

((${#repos[@]})) || { printf 'no git repos found\n' >&2; exit 0; }

default_branch() {
  local repo=$1 ref candidate
  if ref=$(git -C "$repo" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
    printf '%s\n' "${ref#origin/}"; return
  fi
  if ((fix_head)) && git -C "$repo" remote set-head origin --auto >/dev/null 2>&1 &&
     ref=$(git -C "$repo" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
    printf '%s\n' "${ref#origin/}"; return
  fi
  for candidate in main master trunk develop; do
    if git -C "$repo" rev-parse --verify --quiet "refs/remotes/origin/$candidate" >/dev/null; then
      printf '%s\n' "$candidate"; return
    fi
  done
  for candidate in main master; do
    if git -C "$repo" rev-parse --verify --quiet "refs/heads/$candidate" >/dev/null; then
      printf '%s\n' "$candidate"; return
    fi
  done
  printf '%s\n' "$(git -C "$repo" config --get init.defaultBranch || echo '?')"
}

# --- gather rows -------------------------------------------------------------

names=(); currents=(); defaults=(); notes=()
w_name=4 w_cur=6 w_def=7
mismatched=0

for repo in "${repos[@]}"; do
  name=${repo#./}

  current=$(git -C "$repo" branch --show-current 2>/dev/null)
  if [[ -z $current ]]; then
    sha=$(git -C "$repo" rev-parse --short HEAD 2>/dev/null) || sha=unborn
    current="(detached $sha)"
  fi

  default=$(default_branch "$repo")

  note=''
  if [[ $current != "$default" ]]; then
    note='off default'
    ((mismatched++))
  elif ((only_mismatch)); then
    continue
  fi

  git -C "$repo" diff --quiet --ignore-submodules HEAD 2>/dev/null || note="${note:+$note, }dirty"

  if ((show_ahead)); then
    if counts=$(git -C "$repo" rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null); then
      ahead=${counts%%[[:space:]]*}; behind=${counts##*[[:space:]]}
      ((ahead))  && note="${note:+$note, }+$ahead"
      ((behind)) && note="${note:+$note, }-$behind"
    else
      note="${note:+$note, }no upstream"
    fi
  fi

  names+=("$name"); currents+=("$current"); defaults+=("$default"); notes+=("$note")
  ((${#name}    > w_name)) && w_name=${#name}
  ((${#current} > w_cur))  && w_cur=${#current}
  ((${#default} > w_def))  && w_def=${#default}
done

# --- print -------------------------------------------------------------------

printf "${bold}%-${w_name}s  %-${w_cur}s  %-${w_def}s  %s${reset}\n" REPO BRANCH DEFAULT ''
for i in "${!names[@]}"; do
  if [[ ${currents[i]} == "${defaults[i]}" ]]; then
    branch_color=$green
  else
    branch_color=$yellow
  fi
  note=${notes[i]}
  case $note in
    *dirty*|*off\ default*) note_color=$red ;;
    *)                      note_color=$dim ;;
  esac
  printf "%-${w_name}s  ${branch_color}%-${w_cur}s${reset}  ${dim}%-${w_def}s${reset}  ${note_color}%s${reset}\n" \
    "${names[i]}" "${currents[i]}" "${defaults[i]}" "$note"
done

((mismatched == 0))
