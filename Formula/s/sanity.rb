class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.3.0.tgz"
  sha256 "11b8b498a473a82429302b7d1438af0ba1d4ea67e63777eb13b548d94dfea9ca"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e59bc94886132b260ec5a06e9d579a31636008f4b5846b0c7080bb53a259806a"
    sha256 cellar: :any, arm64_sequoia: "afe210afb1cfd5885d62ffd85d7b31bf03b6eaf09ec1a30570fe8d98187476c3"
    sha256 cellar: :any, arm64_sonoma:  "afe210afb1cfd5885d62ffd85d7b31bf03b6eaf09ec1a30570fe8d98187476c3"
    sha256 cellar: :any, sonoma:        "6a70068a8283ba4be508106307c53318aaf8733580ca219a6d164702ed400463"
    sha256 cellar: :any, arm64_linux:   "0b7950361ef69d95aa7d826e30847a644264173873e35b1c2f76a5af73dea3c9"
    sha256 cellar: :any, x86_64_linux:  "5ee5e9dcd746b66aa01b1ff23b2e8cb15552ca631cc28d866266ecab701de66a"
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
