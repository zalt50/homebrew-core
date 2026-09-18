class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.5.0.tgz"
  sha256 "6157a1dfae3262aa93c84605861b674422f4bd025c73c47347ffe20e2868db0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cb73a7643c71a4c31c6e411a1c5d42712d2e61728fe53fdee11d4b71f1ba864f"
    sha256 cellar: :any, arm64_tahoe:       "2cd0f0d11ad0384d9247f967e22886d3c441c24453b158040b676aecc7c49b09"
    sha256 cellar: :any, arm64_sequoia:     "2cd0f0d11ad0384d9247f967e22886d3c441c24453b158040b676aecc7c49b09"
    sha256 cellar: :any, arm64_sonoma:      "2cd0f0d11ad0384d9247f967e22886d3c441c24453b158040b676aecc7c49b09"
    sha256 cellar: :any, arm64_linux:       "3e3e64dfb4b0c2442aadc947ab0baf60a8bcc018df885e8b8dfa3ecd45305779"
    sha256 cellar: :any, x86_64_linux:      "8fb2a594576e0d944a2d17cac81f3dd8c312bf97b0e1f5b4ee6abf0f507e48b4"
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
