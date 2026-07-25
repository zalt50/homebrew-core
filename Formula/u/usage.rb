class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "1f098d4a3d4085649fe6b563b6d04f1752089061a96215f282b668bf89707588"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3706bbe73980971688c2fd0af8c384425b33fc3cb77fc663292c105ff282e052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2375e3d1f4c7bafa23126d2b8fd75f310838b20f9c123437731c645a5bf403b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e021840fe789c054798546cfcc8a09cd8e350d774197ed4b8725b9210d1325aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "488bc4da9c5cef21d7eec95c838797b1ea73c112a6b6398311739f74d0643a68"
    sha256 cellar: :any,                 arm64_linux:   "8a39b24c29710c2cae4154dccef09c2b9dde07453f596cb2b3a8fdbca754232f"
    sha256 cellar: :any,                 x86_64_linux:  "404eca9540990b87cad6175be46027161dbf4023b92f35d62ee4983c4e7e618a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
