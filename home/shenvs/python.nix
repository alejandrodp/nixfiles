{ pkgs, ... }:
{
  static = true;

  packages = with pkgs; [
    pipenv
    (python310.withPackages (packages: with packages; [
      matplotlib
      numpy
      pandas
      requests
      scipy
      setuptools
    ]))
  ];
}
