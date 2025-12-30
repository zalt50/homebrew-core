class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.217.tgz"
  sha256 "4f19d08da73f04b35992e922a8d8840e076b02c0ea835564277c7615c9b1402e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b05916fedd6a512b1137e9df4bee70fa10413a4ae07bdf8bfe65a760a5866ebe"
    sha256                               arm64_sequoia: "b05916fedd6a512b1137e9df4bee70fa10413a4ae07bdf8bfe65a760a5866ebe"
    sha256                               arm64_sonoma:  "b05916fedd6a512b1137e9df4bee70fa10413a4ae07bdf8bfe65a760a5866ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba1fa9def1995f01d9e98ffa2920512d40bfcbb1b7686a84fc9b2916f5f142b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9eb6de80850e1ac10648aa3290de31d601c2f359823d078fd17191156796d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e933423050fbe39134e6960f7c6410ba9477a3498ff1903bcb4aaf995acf74d"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
