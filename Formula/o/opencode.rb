class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.16.tgz"
  sha256 "9aaf04123742053830243598105410c20a0683ebf28dc47c9e4f32189c83d6c2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "79d3674037770f3ce63471d343b4563bd3ce4b0b0a9f90851840e363fd79b0d5"
    sha256                               arm64_sequoia: "79d3674037770f3ce63471d343b4563bd3ce4b0b0a9f90851840e363fd79b0d5"
    sha256                               arm64_sonoma:  "79d3674037770f3ce63471d343b4563bd3ce4b0b0a9f90851840e363fd79b0d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "02251b40af74377cec0890db4ebf134cd5b50bb86e3478c248db4764c3a9a2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6d1f3d203482607c885f57d11e8248b33abe7993c93d8a365aafda118f05a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41037038bfe85a3b12d2a29fc99b4052c3a32232599215f1b44afa6d3e02b5bc"
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
