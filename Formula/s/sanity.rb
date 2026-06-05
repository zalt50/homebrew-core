class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.0.2.tgz"
  sha256 "bdb77d52f5fb8e27ad9120ff4be4860d2db82f3181bbb351131d49cf11b4d6a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "545aac6b4aefc81c7c7b8953fef1268f032b04bc6b845e69b34358ccb7a1f759"
    sha256 cellar: :any, arm64_sequoia: "f4eb2dc0deabe21fc15cd8ab03f9cadbb85998b491c4900d306cd2ee3772da7d"
    sha256 cellar: :any, arm64_sonoma:  "f4eb2dc0deabe21fc15cd8ab03f9cadbb85998b491c4900d306cd2ee3772da7d"
    sha256 cellar: :any, sonoma:        "0ba03922d39f845a9c78dca8ea9ef75ab0ca5e99f5d9e1b227c7a11394f61240"
    sha256 cellar: :any, arm64_linux:   "ede7158cf5a1a8ccdf81dece633b93f18e0300100de6065e09b83a02ea905f9a"
    sha256 cellar: :any, x86_64_linux:  "83d3a77bc8c95753d372fb26e9df38e88bca9071977fce97c8dd2007953b6a2f"
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
