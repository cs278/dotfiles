{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Chris Smith";

    attributes = [
      "*.png diff=image"
      "*.jpg diff=image"
      "*.jpeg diff=image"
      "*.gif diff=image"
      "*.json diff=json"
    ];

    ignores = [
      # Backups
      "*~"
      # Editor configuration
      ".idea"
      ".vscode"
      # OS generated junk
      ".DS_Store"
      "Desktop.ini"
      "Thumbs.db"
    ];

    includes = [
      { path = "~/.config/git/extra"; }
    ];
  };

  home.file."${config.xdg.configHome}/git/extra" = {
    source = ../../files/git/config;
  };

  programs.gh.enable = true;
}
