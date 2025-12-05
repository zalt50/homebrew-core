class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.19.3.tgz"
  sha256 "5a996dbef68f9763ced07a6b90246f8a139c00914adc6fa912a3b92da8c62ae0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb48e8c7b31283479451cfa236fd7444dd2acf8f43767bd749d09dd2edad4474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb48e8c7b31283479451cfa236fd7444dd2acf8f43767bd749d09dd2edad4474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb48e8c7b31283479451cfa236fd7444dd2acf8f43767bd749d09dd2edad4474"
    sha256 cellar: :any_skip_relocation, sonoma:        "def4059d570d59ead3df16b7d159001797c47383bf3310119083cd96deef89b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d29e91267d5855ecf8b639ff67f0313d7e636eeebba25f83721ef64117c7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e62f92fcbd1b59e5ae5c77a9b98e280293d42c6da6573813f902de44e3b115"
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

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
