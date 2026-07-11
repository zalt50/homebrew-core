class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "d5560592f088f5dcb3c94b283cf97f8e88ecd0a873e8fa44bf7eff10ac7488e5"
  license "GPL-3.0-or-later"
  head "https://github.com/dyc3/steamguard-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4526635beb511d5b9fa68881b71474dd15c1dc2f997780a61d1fb9e9c2f5499d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303db37038a5c91e838f8b3066b05993a5f3c0fe4461bdf7705ed75ba07034ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58652499f6e3cdb843ec03e8221d35728f9e8d137266c22a2cf22cc78cdeee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8568a81c6af1bbe8b9c5e20d4e5d33f418e8c4a1f95bf6b5017e3a2b9b6f8f27"
    sha256 cellar: :any,                 arm64_linux:   "745dc2af0a8c0f1bad9a8639cf9439a7fb29493b70693c2debcc3fd2652ca267"
    sha256 cellar: :any,                 x86_64_linux:  "aea21c57b4c878b0f42ae62dcab4a1b6738f9356daf982fb5ba06469dac4a836"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"steamguard", "completion", shell_parameter_format: :arg)
  end

  test do
    require "pty"
    PTY.spawn(bin/"steamguard") do |stdout, stdin, _pid|
      stdin.puts "n\n"
      assert_match "Would you like to create a manifest in", stdout.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
