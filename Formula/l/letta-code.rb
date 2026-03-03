class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.15.tgz"
  sha256 "87bfc56256c7d8880be2df7e1f837cfe08e99b9716ea70b4f31fbe387552d3f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "145f20d247b94b6bb8bb82f2023d382dfd27b93a3343652e250029dbd7568c81"
    sha256 cellar: :any,                 arm64_sequoia: "879722df8ea3d7664ed4f3734d89e0e140380e0b88016714c79d2373d8621a75"
    sha256 cellar: :any,                 arm64_sonoma:  "879722df8ea3d7664ed4f3734d89e0e140380e0b88016714c79d2373d8621a75"
    sha256 cellar: :any,                 sonoma:        "da6c5cb06440c7ba94e58a84eb096f805ba3cbc4c70ce3512119cf49283ae4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc706c8dcb150bda4c5c47d009f60de443fecece6783a0cbb978953ecce9fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f434313c28e59bb8eaf6061ce62c7956f2691648577758b37c5e327ed59d26b"
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
