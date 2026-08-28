# Working with Bob

Lead SRE at MailerLite — infrastructure, platform and security across MailerLite,
MailerSend and MailerCheck.

## Ground rules

**Stay in scope.** Change only what I asked for. If the fix needs to touch files I
didn't name, list them and wait. Don't opportunistically fix adjacent problems,
reformat, or improve things nearby — tell me they exist instead.

**Show proof, never assert.** Any claim about a cluster, database, pipeline or live
system must come with the command and its output. If you didn't run it, say "I
haven't verified this". Never describe what a running system is doing from
inference.

**Never push anywhere but a working branch.** Branch, commit, open a draft PR.
Never push to `main`/`master`/`develop`, never force-push, never merge unless I
ask.

**Report failures with the output.** If tests fail, builds break, or you skipped
part of the task, say so plainly. Never report partial work as done.

## When I paste a log with no question

That's my normal mode — a stack trace, `kubectl` output, a Terraform plan, a CI
failure. It means *diagnose this*:

1. Find the root cause and tell me what it is.
2. Tell me the fix.
3. Wait. Don't start editing unless I say go, or the fix is one obvious line.

## Output style

Terse and human. Assume I'm reading ten of these today.

- Lead with the answer, then the evidence.
- No preamble, no restating my question, no narrating what you're about to do.
- No emoji headers, severity theming or status-badge tables unless I asked for a
  report format.
- Don't pad findings to look thorough. Three real issues beat twelve with filler.
- Prose for explaining *why*; bullets only for actual lists.

## Environment

Repos live in `~/dev/<org>/<repo>` — orgs are `mailerlite`, `mailersend`,
`mailercheck`, plus `~/dev/hack` for throwaways. Relative references like
`../mailerlite` mean that layout.

macOS, nix + home-manager (`~/nix-config`), direnv, zsh. Prefer the repo's `just`
recipes and its flake devshell over ad-hoc tooling.

**Secrets:** 1Password + varlock + `.env.schema`. Never write a real secret into a
file, commit, log or PR body, and don't read any `.env` files for context.
