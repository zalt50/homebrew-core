class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.2.0.tgz"
  sha256 "09eb312c7a1a20b3d9157b01d03c35af17f8424624659cd04c1d0906f5a7e363"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1add232d6d6130dbde9516830d7d9c6b754968053e818fa7fbeaa9985d8ca746"
    sha256 cellar: :any, arm64_sequoia: "c824778a0d7db903ff8c7c803ce9b7c68ceb775bcd166f94feb710b8a5063d91"
    sha256 cellar: :any, arm64_sonoma:  "c824778a0d7db903ff8c7c803ce9b7c68ceb775bcd166f94feb710b8a5063d91"
    sha256 cellar: :any, sonoma:        "b472a164cda4307701e7484394be37cfc88ba79212545e84054947df87dcd13c"
    sha256 cellar: :any, arm64_linux:   "6a614f293bcd7ddf345d4f354c37f0ba532096b28c6ed25f108c7de38e427600"
    sha256 cellar: :any, x86_64_linux:  "b1178cf0b83f3c48d15fa2bd6332e34b5c1eef647040afcd9cd1f1e90a5f9ef3"
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
