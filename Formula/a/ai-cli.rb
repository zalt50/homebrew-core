class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.5.0.tgz"
  sha256 "6157a1dfae3262aa93c84605861b674422f4bd025c73c47347ffe20e2868db0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c1b05abd8ee15dfe09dd95e88c72468ca3c2e86d31832e6c4e20009c6548da7f"
    sha256 cellar: :any, arm64_tahoe:       "c1b05abd8ee15dfe09dd95e88c72468ca3c2e86d31832e6c4e20009c6548da7f"
    sha256 cellar: :any, arm64_sequoia:     "c1b05abd8ee15dfe09dd95e88c72468ca3c2e86d31832e6c4e20009c6548da7f"
    sha256 cellar: :any, arm64_linux:       "5123fbfe9a3151efa1440beb3c3a4ceaffc8a47cf9849ae2793276e99d8e680e"
    sha256 cellar: :any, x86_64_linux:      "f7a791114eb56eba073a3b09a5a7cd728c259b279d0a1dca6ed61f1813dd43e4"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
