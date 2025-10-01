# Setup (Fresh Mac)
## Install Command Line Tools (includes git)
On a fresh Mac, you'll need to install Xcode Command Line Tools which includes git and other essential development tools:
```
xcode-select --install
```

## Clone repo

```
git clone https://github.com/robgordon89/nix-config.nix
```

---

# Install Nix
## Install Nix with installer from @determinate
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

---

# Init Nix Config
## Bootstrap nix-darwin (first time only)
On a fresh machine, `darwin-rebuild` isn't installed yet, so you need to bootstrap using `nix run`:
```
cd nix-config
nix run nix-darwin -- switch --flake .
```

After the initial bootstrap, you can use the task commands:
```
nix develop
task build
```

---

# Updates
## Rebuild config
```
task build
```

## Rebuild config
```
task update
```
