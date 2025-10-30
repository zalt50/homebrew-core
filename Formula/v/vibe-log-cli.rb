class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.4.tgz"
  sha256 "0333995c3aa99e029410c151315b993bee8f6e708a19037cf790cc8f899cfa01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c231d326670398d397ff3153ce5e23f9908fd264ace8f9bef80045b7d5e02a2b"
    sha256 cellar: :any,                 arm64_sequoia: "c4810dd59fbfee745729f6a3387d63aa62bcc90fdb7aeb772e6a9fb260a96e82"
    sha256 cellar: :any,                 arm64_sonoma:  "c4810dd59fbfee745729f6a3387d63aa62bcc90fdb7aeb772e6a9fb260a96e82"
    sha256 cellar: :any,                 sonoma:        "8329062b20a68f217da43756c5c83cfdab42b5d4da7aabf2e3e4d4f93c67c965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f2e12bd9f51d952c3ae76431c60163a8c37d9895cb54ffe4e8acaeba764461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358b0d4d6d4bd5e1a9b3751811e2444d6038acf07737021ad4ebc0a577ec31a9"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end
