class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.0.2.tgz"
  sha256 "1813cafa69e594e5e235b2a6034307b63a8192a2e8156e414a41f9e7111766fb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97d63d36fafa37fe898342b60be12c474fad83051173bf0f7b18fda77d1f0410"
    sha256 cellar: :any, arm64_sequoia: "97d63d36fafa37fe898342b60be12c474fad83051173bf0f7b18fda77d1f0410"
    sha256 cellar: :any, arm64_sonoma:  "97d63d36fafa37fe898342b60be12c474fad83051173bf0f7b18fda77d1f0410"
    sha256 cellar: :any, sonoma:        "4f5205dc84f406476bf016cb60eeb05e3c62b558f5870aa36476e0c1e2156ead"
    sha256 cellar: :any, arm64_linux:   "460c7032f7311e671fd9c4eadeba9ccdc62deb50c7c687ab88a5838b53b0c79a"
    sha256 cellar: :any, x86_64_linux:  "d395e4b7eaf1a389984e37f69b63a931924dbf7feb4c5110633bb4e2a6d82985"
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
