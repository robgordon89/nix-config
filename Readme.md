# Install Nix
## Install Nix with installer from @determinate
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

---

# Init Nix Config
## Run Nix develop (first time only)
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
