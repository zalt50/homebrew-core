class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.19.4.tgz"
  sha256 "2ae7ab76decd7133d2fd72993860e5860c4fcbe3b570855de73db11cb417b4b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172da6f459430450b97faceaaae33239d5b212c0636a67ed2f45e9f7a52851be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172da6f459430450b97faceaaae33239d5b212c0636a67ed2f45e9f7a52851be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172da6f459430450b97faceaaae33239d5b212c0636a67ed2f45e9f7a52851be"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ddd8eb636a809cd6c4ea8657b70ada836dfedc97abe2a6e95224c33947fd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca663bfdea35e0d154085f79f54951b4548b94bbddb17ef7f8b1c1493e8cf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9733f04a396334db358e0e26ad7914994b4bbb0f965da87decd26763b5592365"
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
