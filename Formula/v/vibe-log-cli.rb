class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.4.tgz"
  sha256 "0333995c3aa99e029410c151315b993bee8f6e708a19037cf790cc8f899cfa01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8a32edb59f36371e41f8b9832a07b8c0954a86614cd1c614dd7d3003657c3ca"
    sha256 cellar: :any,                 arm64_sequoia: "919deee0f65d467307e724e05d54575a0964b1d3b692e283d68d25afd7a9555e"
    sha256 cellar: :any,                 arm64_sonoma:  "919deee0f65d467307e724e05d54575a0964b1d3b692e283d68d25afd7a9555e"
    sha256 cellar: :any,                 sonoma:        "9ca01cb29945ffbd0598b72e23582bf4579ea845f84fb14589b7d0402eb1f00f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7af7583d5d627a88e00cb8e369d51840491709cd936dce4ccdae4048d9816b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c06610794232aec2a9904492695bd54821666728d58b962aa6ced524673ed8"
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
