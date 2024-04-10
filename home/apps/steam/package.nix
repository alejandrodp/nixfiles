{ writeShellScriptBin, steam-run, steam, ... }:
writeShellScriptBin "steam" ''
  exec ${steam-run}/bin/steam-run ${steam}/bin/steam
''
