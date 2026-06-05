class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.0.0.tgz"
  sha256 "ddca742832b137880f1777bf2f6260bd3be5b6a2cb7daa2597cb0817aecafcec"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "279879c8d3ab99351fa61a517e7a7efba034cd2bbb5019b57c65dd686eb40ef0"
    sha256 cellar: :any, arm64_sequoia: "21ae2080d58731f93ba33dc1ad19e3b1caf6a5db25985226413f865beb48a1d2"
    sha256 cellar: :any, arm64_sonoma:  "21ae2080d58731f93ba33dc1ad19e3b1caf6a5db25985226413f865beb48a1d2"
    sha256 cellar: :any, sonoma:        "1c9b85226ffaedf9796b2c39feab4e82e7e0604c271472a9127013e8ab8253b3"
    sha256 cellar: :any, arm64_linux:   "9d66158840e67d010efda644e44f76df57c9222aa93d7a08f9512ac6447a2847"
    sha256 cellar: :any, x86_64_linux:  "150a903636ccc83a5d085fada7baca0ee885d5357fe9f2a1710715edd4cfc303"
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
