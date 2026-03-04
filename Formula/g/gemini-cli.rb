class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.32.1.tgz"
  sha256 "5ac01b1abc59171a675698d6902e6674fae5a8a771342b5b2e039aed54b0a241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11e9deb9ea668eb133540a03121b7cce949025f19b6956a03a6bf60a09dc820c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e9deb9ea668eb133540a03121b7cce949025f19b6956a03a6bf60a09dc820c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e9deb9ea668eb133540a03121b7cce949025f19b6956a03a6bf60a09dc820c"
    sha256 cellar: :any_skip_relocation, sonoma:        "828c610760262c2b6492464647441aeddd790db61300e86cbd85df02e944c67d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bc9632d13e2d0ef31a7c139aa5ba3b7eec50898d7afe8c5989b500f4f3cb1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb89dd3f3d60891586d47c1d8ae791fe19c3ec922374e5c6cec23ee9d8bf315"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
