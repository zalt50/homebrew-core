class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.6.0.crate"
  sha256 "08c62af9512ab97999497dd8e8e9c5326c42df4dae42918faece5f4b262df247"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2bb2adceb01b39576383661c2e83920920b710d7870c95e51d8d9a982db7e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ebbc973c170ac9bf587b850e85176732fb0c77950850dc70b1770c48e154531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d30185f2d0a9ffade11bbeab852c4e4b22facd3a741325ad97f4987a7e36b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "84751c79f98d8680bca622b676788c8130d7e431a429d5db0529f00142205007"
    sha256 cellar: :any,                 arm64_linux:   "97e9f170f8bf3eb8f33a77f3f7b04ca68150232858c3c5d9948993bf20e0ea1c"
    sha256 cellar: :any,                 x86_64_linux:  "0f51c542bebc268733cb2d47f4d19f1b9a23b1a61533b983ea74470ae77eba83"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
