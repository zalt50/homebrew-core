class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.11.0.tgz"
  sha256 "c08a26486a0b8b766c0046047f5ea69236dd9bef9202bd528f31a6c1663967b9"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "7633d3776c834c9e3ef0bb32ae1f90afa3d944895847b02ce87f3f7c4db991c4"
    sha256                               arm64_sequoia: "e73ccc3f8c40780fc49bd02c31bca0af1da6377d183c0c251ab1d48cf477d580"
    sha256                               arm64_sonoma:  "002ecb26b2e61d6b915e6b0fdb3d591255d6401b09a04a3c30ddcaaa59513f81"
    sha256                               sonoma:        "d87057dd872558778d6ba16f1235f5cf449b66fe77f9b5c6acac55134f45a6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3604d62e7b2dfcd4a3bfd5eaa817d0c306aba527673a3de2442c39df97272a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2d1dcebb2db2b3dc52faed000cdf849aa56a9f670580f2396f536a72dc13c3"
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
