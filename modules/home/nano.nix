{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home.file.".nanorc" = {
    source = ../../files/nano/main.nanorc;
  };
  home.file."${config.xdg.configHome}/nano/git.nanorc" = {
    source = ../../files/nano/git.nanorc;
  };
}
