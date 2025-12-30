class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.209.tgz"
  sha256 "77e18472c87ae7cbbf4bef425ffc725d45fde93b71a02c90dc90e1fa35bd2458"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "73706f8f74328de1d80a4c0e0cce357fced120803f7fbcdc6726d98b1624b65e"
    sha256                               arm64_sequoia: "73706f8f74328de1d80a4c0e0cce357fced120803f7fbcdc6726d98b1624b65e"
    sha256                               arm64_sonoma:  "73706f8f74328de1d80a4c0e0cce357fced120803f7fbcdc6726d98b1624b65e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3263f8ecc91fe8ff2cd34f730e52ba1e7488abcd5b4df95232f7d438799fa37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25118dc4832f0499d28e8e919fa45517b7594b97d142bf694e932a6056dea4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663b0eef25f758339c716274704346753f084e8c7b6ee3b9b1d3a18891bc56ac"
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
