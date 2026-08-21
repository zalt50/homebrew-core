class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.2.1.tgz"
  sha256 "0dd6be0804a85b87cde0c243eb1e8428f37b72b3e0f093c734dcd19b03ac9628"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80def520e7b972b76aac2486c883a7277c3a7e739d2aa5e40a659c9e171ca792"
    sha256 cellar: :any, arm64_sequoia: "80def520e7b972b76aac2486c883a7277c3a7e739d2aa5e40a659c9e171ca792"
    sha256 cellar: :any, arm64_sonoma:  "80def520e7b972b76aac2486c883a7277c3a7e739d2aa5e40a659c9e171ca792"
    sha256 cellar: :any, sonoma:        "1bb8b2fc71e8e74e74ffa4f051b920b67f149b84a8ed961cfe5c6f204a3b01c3"
    sha256 cellar: :any, arm64_linux:   "fe95b1fa351472b96836b2013e2057a61ed15734da74e4b8d7f350778e42faa3"
    sha256 cellar: :any, x86_64_linux:  "2a5316ea27a219682b82fff46376241f2ae1bac07e1e2d5b4fb921af425b69a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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
