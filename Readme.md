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
## Run Nix develop and build (first time only)
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
