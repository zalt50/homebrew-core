class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.17.1.tgz"
  sha256 "85598581662c9eb7c3a9ab067b8a711016219d0e01951a2d5cc1d9c47adc4a5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3098b026f94cf0c0221b9003eb551b50d55fa719d19c3e7db47ea29c4d76609a"
    sha256 cellar: :any,                 arm64_sequoia: "c5cf284105aec44742cfdcbf283dc8af2cbf5569a1b535f62c9d2db0526ec096"
    sha256 cellar: :any,                 arm64_sonoma:  "c5cf284105aec44742cfdcbf283dc8af2cbf5569a1b535f62c9d2db0526ec096"
    sha256 cellar: :any,                 sonoma:        "452106d85469536b0cb43ab4a55856578bda34d589beb9f1e206917c810fd9b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f506973671ff72501ed058d2a667dc5764cea42f401eb4c3447241798f21cf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87d999ed1cc598ac61e3e2d868c6dd5f866b39596608631c6c199880a320730"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
