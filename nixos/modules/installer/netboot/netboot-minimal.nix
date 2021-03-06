# This module defines a small netboot environment.

{ config, lib, ... }:

{
  imports =
    [ ./netboot.nix
      ../../profiles/cerana-hardware.nix
      ../../profiles/cerana.nix
      ../../profiles/minimal.nix
    ];

  # Allow the user to log in as root without a password.
  users.extraUsers.root.initialHashedPassword = "";
}
