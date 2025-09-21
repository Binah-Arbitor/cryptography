{ pkgs, ... }: {
  channel = "unstable";
  packages = [
    pkgs.gcc
    pkgs.gdb
    pkgs.cmake
    pkgs.make
    pkgs.jdk
    pkgs.gradle
  ];
  env = {};
}