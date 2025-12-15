class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.155.tgz"
  sha256 "08599857771c8b0b0b251f7004ff1779a63f5ba8dec9be972af77e5a06ebcba2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5b2bea15c24e802ac7070a733e5724a4ca449f58887131cfac5731ccb7e328e3"
    sha256                               arm64_sequoia: "5b2bea15c24e802ac7070a733e5724a4ca449f58887131cfac5731ccb7e328e3"
    sha256                               arm64_sonoma:  "5b2bea15c24e802ac7070a733e5724a4ca449f58887131cfac5731ccb7e328e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d123309db352810a8821fda2eee79a9cbb78b6dd3b3ee83b225734a670599fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84d8e4382e2a20205959ed3d53f15a5b5a0cb5be7952c7ec56771565159b56e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d71849f9973129c930e67091c11ed55b8673f164e74d06efe4270cf2b8494a9"
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
