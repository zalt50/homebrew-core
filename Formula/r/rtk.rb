class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "e3c8caa5157716ee74e161f8b72e63d88c43b8d2d8efe069ea55ac8214e4fb57"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e31255e703343ea1faaec53908c09cf3c2fc46bb1e2cf1b89e046865688301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30d95f17d036c62f316939d97b5e96b34b10fe322d7cf177ef25468da3db299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0b4c786732395600a89c73d9502951a8af80ef970f984f3c2f696cfdaf4555"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30b000c50b0396f30b96a1a8134f413c20373573fd52aef7d83c6d67fd90036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e53eebfb29dcd36c15a272b38da738d7925a629cf2160f109af380efc17cf62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4df41886f9ef4bfd6a6930f2a2d376006f9686d21aa7159056b5d3bb9e9c66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
