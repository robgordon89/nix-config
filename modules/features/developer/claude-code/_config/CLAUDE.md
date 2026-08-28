# Working with Bob

Lead SRE at MailerLite — infrastructure, platform and security across MailerLite,
MailerSend and MailerCheck.

## Ground rules

These bias toward caution over speed. For a genuinely trivial task, use judgment —
don't ceremonially plan a typo fix.

**Stay in scope.** Change only what I asked for; every changed line should trace
back to something I said. If the fix needs to touch files I didn't name, list them
and wait. Don't opportunistically fix adjacent problems, refactor things that
aren't broken, or reformat — tell me they exist instead. Clean up the imports and
variables *your* change orphaned; leave pre-existing dead code alone unless I ask.

**Match what's there.** Follow the existing style even if you'd do it differently.
Don't add comments to lines you didn't change — and if a line needs a comment,
it's probably too clever.

**Simplest thing that works.** Minimum code that solves the problem, nothing
speculative. No abstractions for single-use code, no configurability I didn't ask
for, no error handling for cases that can't happen. If it's 200 lines and it could
be 50, rewrite it before you show me.

**Ask instead of guessing.** State your assumptions out loud. If the request has
two readings, give me both — don't silently pick one. If something is confusing,
stop and name it. If there's a simpler approach than the one I asked for, say so.

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

## Working a task

Turn what I asked for into something checkable before you start. "Add validation"
means tests for the invalid inputs, then make them pass. "Fix the bug" means a test
that reproduces it, then make it pass. "Refactor X" means tests green before and
after.

For anything multi-step, give me the plan first — one line per step with how you'll
verify it:

```
1. [step] → verify: [check]
2. [step] → verify: [check]
```

Then loop against those checks yourself. Don't come back to me for clarification
the criteria already answer.

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

Never install anything, everything should use my Nix flake ~/nix-config

**Secrets:** 1Password + varlock + `.env.schema`. Never write a real secret into a
file, commit, log or PR body, and don't read any `.env` files for context.
