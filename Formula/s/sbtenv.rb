class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https://github.com/sbtenv/sbtenv"
  url "https://github.com/sbtenv/sbtenv/archive/refs/tags/version/0.0.24.tar.gz"
  sha256 "f483769e5467c718c9de72baa4eb3c679315e4f4a9ac02bb636996a63c28e3d5"
  license "MIT"
  head "https://github.com/sbtenv/sbtenv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6e5520ead3c64eb3f68e1bbc7e54ee271aaf36b1bc2b442b9514269df90a7047"
  end

  def install
    inreplace "libexec/sbtenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    bin.install_symlink prefix/"default-plugins/sbt-install/bin/sbtenv-install"
    prefix.install_symlink (var/"lib/sbtenv/plugins").mkpath
    prefix.install_symlink (var/"lib/sbtenv/versions").mkpath
  end

  # Var symlinks must be done in post install as bottling converts symlinks to real files
  post_install_steps do
    ln_sf "default-plugins/sbt-install", "lib/sbtenv/plugins/sbt-install", target_base: :var
  end

  test do
    shell_output("eval \"$(#{bin}/sbtenv init -)\" && sbtenv versions")
  end
end
