class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.15.1.tgz"
  sha256 "a6e2f8d5706d6ed10489a52cd4efa0bce5c84affb7302fd385dc42d72540df97"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "962e531e531e444a9dd541f09f8b0f26686c32162dd2f0f285f6b4a99181e5a4"
    sha256 cellar: :any, arm64_sequoia: "962e531e531e444a9dd541f09f8b0f26686c32162dd2f0f285f6b4a99181e5a4"
    sha256 cellar: :any, arm64_sonoma:  "962e531e531e444a9dd541f09f8b0f26686c32162dd2f0f285f6b4a99181e5a4"
    sha256 cellar: :any, sonoma:        "ddfb8231cd2022376da7cc42667d6ecf57a1b55ba17d3532103b5a47dcb05847"
    sha256 cellar: :any, arm64_linux:   "1ccde19cd4a05be2af16ce0f8e5720029e000df2401beb705c5b8ba61054dd4f"
    sha256 cellar: :any, x86_64_linux:  "bb05d79e33df640d28ffd29432cc44c3bd2b726c3443c5a8e107a98ed4ff7a50"
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
