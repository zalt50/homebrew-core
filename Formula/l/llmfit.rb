class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "ae6f19e0980dce28fb2dcc3c222881d08ae564a3ece7f58ff19cfb3bbf506ea3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1befe1f250da6d1519d8fdd7e9d121fbb16bea281ad9bc751dd4f0db79f9a050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348202eacb7e4a275ff71058a2c5dfe2b584ff192123244385fdbfd83c652330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a9a69de8a33ce2abcd8dd59b60f2bf01173d5eeaed625aa269fe4d2fd67cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbdec87a40146d5b59968bb1683ade48935dda82cf5b734acfd3fa2e28e8e1e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f988d2b39ee4875d2783b079c4a31dc78a2af2c19648f4ffaaaea2428f215fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc777903f1157fd2c15968942bbefc338c8407b8463ce5b67a4de6c930c0ba9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
