class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.11.3.tgz"
  sha256 "277710db32268d5de9801ea6745f1b697d07006f4d160415b2d6444437d83d1d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "bd2aac166c28f490cd293180ca93bda2658697086f0f662d8bba7f12ded1e12f"
    sha256                               arm64_sequoia: "b4918276ae085d90e1a6b4aa96e83f57ab5ae657bbf11762947503ba286f5262"
    sha256                               arm64_sonoma:  "a46207a88a3e135045ee66ef06f814bbf0195c3321bf709f0b38637d2740f1dc"
    sha256                               sonoma:        "614391e367ccbc8763465893df18f8be08ff04778030ea710a2bac83b34349f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6794f5f52d563f38b9c2f479c7475e8c21004defdb497aab3c806d2cac68c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a9fdbb44de4c1d4edf5409459ceea9b05a8a3aa653c1c638b2513eedb2091a"
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
