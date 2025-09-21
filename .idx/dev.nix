# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }:
let
  # Configure the Android SDK.
  # We specify concrete versions for stability.
  android-sdk = pkgs.android-sdk.compose {
    # Use the latest available command-line tools.
    cmdline-tools = "latest";
    # Use the latest available platform-tools (adb, fastboot).
    platform-tools = true;
    # Specify a recent build tools version.
    build-tools = ["34.0.0"];
    # Specify a recent Android platform version.
    platforms = ["android-34"];
    # Include the Android NDK for C++ development.
    ndk = true;
  };
in
{
  # Which nixpkgs channel to use.
  # Android tools are often updated, so "unstable" can provide more recent and fixed packages.
  channel = "unstable";

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # For C++ development on the host
    pkgs.gcc
    # For Kotlin development
    pkgs.kotlin
    pkgs.jdk
    pkgs.gradle
    # Add the configured Android SDK to the environment.
    android-sdk
  ];

  # Sets environment variables in the workspace
  env = {
    # Set ANDROID_HOME and ANDROID_NDK_HOME for tooling to find the SDK and NDK.
    ANDROID_HOME = "${android-sdk}/share/android-sdk";
    ANDROID_NDK_HOME = "${android-sdk}/share/android-ndk";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "google.gemini-cli-vscode-ide-companion",
      # For C/C++ development (useful for NDK)
      "ms-vscode.cpptools",
      # For Kotlin development
      "fwcd.kotlin",
      # Provides rich Java language support for Gradle and Android
      "vscjava.vscode-java-pack",
      # Extension for Android development in VS Code
      "google.android-ide"
    ];

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Accept Android SDK licenses before use. This is required.
        accept-licenses = "yes | ${android-sdk}/bin/sdkmanager --licenses";
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ ".idx/dev.nix" "README.md" ];
      };

      # Runs when the workspace is (re)started
      onStart = {};
    };

    # Previews are not typically used for mobile app development.
    previews = {
      enable = false;
    };
  };
}
