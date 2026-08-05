class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.18.0.tgz"
  sha256 "743bf8c50af072509a3f4d74a557adbf215f4b91ce6b6d59b6ad0564c9abe36b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9da11c273bfa402c1ae686d6912acdfac9f2e287a1229ef758e24107176e51b3"
    sha256 cellar: :any, arm64_sequoia: "9da11c273bfa402c1ae686d6912acdfac9f2e287a1229ef758e24107176e51b3"
    sha256 cellar: :any, arm64_sonoma:  "9da11c273bfa402c1ae686d6912acdfac9f2e287a1229ef758e24107176e51b3"
    sha256 cellar: :any, sonoma:        "e9cce694410f8c31a379b489d21ab79dc5383188cf77713f1f3cd0e4399219ea"
    sha256 cellar: :any, arm64_linux:   "3c856b1cb89cdd3ba9c00c6740b18b75d0077272971811d60d9ac12004fa9e5b"
    sha256 cellar: :any, x86_64_linux:  "150b9c85a6efb745af0168b6efb722378b838bdf55af5ecb87797267f074caa2"
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
