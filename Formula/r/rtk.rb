class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "1ceacb8506d0e2b363fc4cbb384d576ce26f5e6752cf3e092248141b0a858404"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddafd00a565439e8ef6ee5ddd9d8daddb9173bcb5664b911cbb88b61778d0e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96dbf3e00ffe224e0981b11ae4b9c2e1e4e4aefebc2d9d224225077180c7dcc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "733d30c981d2069a2d5d510f3f87c2b065f3886a1b63339930e65a31714128d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2250541c21965ce9497c8dcdb946f9686e4a145057e4a4e97a134bdaf5d0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae86335f58ec8b04d7e79809b79fd5e57f12d7d11cd6e5857da82c5046f4b1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c833b91de41f11ae195e4f71536835e148eead380802d567aa0bf1ff98873f80"
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
