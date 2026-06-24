class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.3.tgz"
  sha256 "a29ffed523c888368d2ade6c482656480cbe0cff83da34323cc896f31da8726d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "24ee9dc1723f272dd5f68caf2ff86484c43ba2057abe0ae50fce1cf81663eb15"
    sha256                               arm64_sequoia: "24ee9dc1723f272dd5f68caf2ff86484c43ba2057abe0ae50fce1cf81663eb15"
    sha256                               arm64_sonoma:  "24ee9dc1723f272dd5f68caf2ff86484c43ba2057abe0ae50fce1cf81663eb15"
    sha256 cellar: :any_skip_relocation, sonoma:        "9931340bdaee3b10e5f8d07ecd0ad1abb3eaeae121bc679b7bf9ec0d0091a5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a0669f50368bb07ed17dd09ac3fd5e4292a871fde4321ef9d7012a80c64910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6743b0b0ff8cc714594c2069dd4a7701163061a02772fbaafc69ff2fd8055cf3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
