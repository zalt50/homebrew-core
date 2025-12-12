class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.20.1.tgz"
  sha256 "6070c2e658089662fb5f1750b3bcf76f09fbf5bd96a8c3aa89870785e2f951fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d65dcaff6331962f537936dbea6186344d94a8988cd0760b419e9a7e18129d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d65dcaff6331962f537936dbea6186344d94a8988cd0760b419e9a7e18129d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7d65dcaff6331962f537936dbea6186344d94a8988cd0760b419e9a7e18129d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf1f87c5dd089bde1244b9ae818530089df883fd9b3d32a876005d0cb1f9f4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d035929e0ca1f45a5467be030a6223aae04823a940a9cf68c24e4bfd20e95aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306272521d5b91e144ad4ed66d29b2341417ff040ff45748459af95162a6caa0"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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
