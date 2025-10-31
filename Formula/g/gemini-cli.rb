class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.11.1.tgz"
  sha256 "0dbd27a044d9677dcf030dff5135ac266675113615370cc8a769b453f73d24a5"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "240a3dfb37b6c35104a053771b1987326e97e138b4a7137995361a5089d120fd"
    sha256                               arm64_sequoia: "0cf9d8a92b44c39c11c78f9e5599ad01cad8f75b4588689c5c2e6b955b371207"
    sha256                               arm64_sonoma:  "8cd87cd303531f02db6f249a6cc3c293b8dce1d182042ddf8ef07ede2a4849e0"
    sha256                               sonoma:        "d3554dd75a19e209bf518955882b885a6fc6009800f8f66742f25df5c58d1489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a380a255cdb72df1b9158f0c69686da140a68045293535f3161fab972cee1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45737f8d65dfe4441c50777fcf2ef791d1105f55f9bba4fce504aa0562b990c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
