class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.49.tgz"
  sha256 "4518e9704fcad664c960326ab0de2862123666885dd14ac9c57885035fa26769"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "242b5d2951f935a2480c9beece4bcce1facd6e0a41c162f0b7ca66289c1990ed"
    sha256                               arm64_sequoia: "242b5d2951f935a2480c9beece4bcce1facd6e0a41c162f0b7ca66289c1990ed"
    sha256                               arm64_sonoma:  "242b5d2951f935a2480c9beece4bcce1facd6e0a41c162f0b7ca66289c1990ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8493313e34078f5c04cac1c2ecd28d400cb0686dc2a149937c45f2dc795b523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23edc021492aae1dea99b00fc097a085c78f1fbb1fbcadca9baeceaf61f11b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412ba6d4fb04222ecb249839d927bfbc0c83303c2be6ed4f2d6461ab7d9ba3db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
