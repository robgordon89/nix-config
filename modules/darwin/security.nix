{ ... }:

{
  # Allow the user to use sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;
}
