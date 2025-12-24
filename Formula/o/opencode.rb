class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.194.tgz"
  sha256 "224bbc0f0739b81e23be552228c592c9b6711c69c5f214f4cb5292acd3c51620"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a965a54abdf0ea361da43d2d088779f3fe6f5240556afec18f5cb6b069f837d2"
    sha256                               arm64_sequoia: "a965a54abdf0ea361da43d2d088779f3fe6f5240556afec18f5cb6b069f837d2"
    sha256                               arm64_sonoma:  "a965a54abdf0ea361da43d2d088779f3fe6f5240556afec18f5cb6b069f837d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4661185511350d0ad4b2249eb74f66a84b095105c26477f8cb2ba0f31ad8fb00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ea9f3d53103fd3f60e46b6a11cb3170671625a72b8a4edf94ba5d08728a491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b594766846d31d1dfcb83b7fe88d5eb63ece4a0f461551deb6fc3fc959a82026"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
