class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.2.3.tgz"
  sha256 "1683ccf22ef8dd793733d52a9c05ef88af204d45caed9f7e3ca3064ec9aa8a32"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "92df6cb257c39a634321824f8f7afe3a199de5e6572a03cada9728e244c7aa62"
    sha256 cellar: :any, arm64_sequoia: "4cae4b1e48d60b29b748e9981a18f1103bb8582fc80ec4b61ff8826acbdfe8f0"
    sha256 cellar: :any, arm64_sonoma:  "4cae4b1e48d60b29b748e9981a18f1103bb8582fc80ec4b61ff8826acbdfe8f0"
    sha256 cellar: :any, sonoma:        "bceabd3146dd880603b3ae9f144678268b3f0f46a6403e83537e72e3922e14fd"
    sha256 cellar: :any, arm64_linux:   "a9578a965c9305f8d530fff84523dd547ce1013b363c28b79f6ece52fca8f7ac"
    sha256 cellar: :any, x86_64_linux:  "580a8bfc1d68767a8e6613971f8a5a428cbcdc4369f1e004bbe9e5e929057ef9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
