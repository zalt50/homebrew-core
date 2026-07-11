class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "ed6f3ddce2cf7f377cbe1463ea051e2091bb185536c8849b346fd258137ac093"
  license "GPL-3.0-or-later"
  head "https://github.com/dyc3/steamguard-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3051b5915ad5d2eeadd416e10d845fa8d0afb9888e90e88dbc6a5c2c07b16bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283a860a41c2678b489b929b39a53a50a6685ffde51ae5cdec479d0cb5bebe9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f666b5117aa58c6b6022abde9a89d3c01fb3bff78fb05dfa5e9761962d7763"
    sha256 cellar: :any_skip_relocation, sonoma:        "312fe142210e875c62813885cde814427deec87603bc478ab8a5403b20d0a249"
    sha256 cellar: :any,                 arm64_linux:   "cd5bbd9459185a9cbb7149ce8335df26fb726af3c9a222a784ef8cd1b732f6fe"
    sha256 cellar: :any,                 x86_64_linux:  "1f3f82041feece9dff813ca14ee73da512d507e2e8723f655bfd822e0337b401"
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
