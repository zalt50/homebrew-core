class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-6.7.1.tgz"
  sha256 "b6a59e4c248f80b3ed8f4e922a4150d89695a33754d314d20b1f67c7895ec6ac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "249ce8126e9a39c9069c2e5448e386abfa98df498c7e845110bbe78a205970a1"
    sha256 cellar: :any, arm64_sequoia: "d6bae7a5644e064733971e2808fb29433d4a3ab31550d36efa35add16def24ff"
    sha256 cellar: :any, arm64_sonoma:  "d6bae7a5644e064733971e2808fb29433d4a3ab31550d36efa35add16def24ff"
    sha256 cellar: :any, sonoma:        "2e46b0f3bc43a558af258f3ab7b1e7f5f21c8f21aad6309339740484134b67ef"
    sha256 cellar: :any, arm64_linux:   "28df18a502723315874674f3293e1f142325a5550733df48a15c17a6d565306a"
    sha256 cellar: :any, x86_64_linux:  "ebabe4538264be645b0313ed96f96b56e32f3f1084ce9792db20a616b3eb126d"
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
