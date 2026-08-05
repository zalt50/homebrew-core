class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.9.0.tgz"
  sha256 "8ad9a383562eb0cb56fc8882db4507eef5aae8475299f2a198d4b1bf7e7cb4a5"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1abcac0a43f866ced34c1739c2ce7e2b17152b8d2982589bfaf6fb9e8d8dc3b7"
    sha256 cellar: :any, arm64_sequoia: "16a9547397511db3680748e1e243c04425326efebd728c59a5b5cb2327fc4307"
    sha256 cellar: :any, arm64_sonoma:  "16a9547397511db3680748e1e243c04425326efebd728c59a5b5cb2327fc4307"
    sha256 cellar: :any, sonoma:        "3e0b1883cb0302a6c5d8173f1a6394e9b1329522c3a6be2e7198fccd2612aa6c"
    sha256 cellar: :any, arm64_linux:   "3be630b5c0d5074a678f33b6d7c821b2ddbc11a2d2ac43f317b5f07b79b8e030"
    sha256 cellar: :any, x86_64_linux:  "8e6a998f15a26859c7d5d27a9c0b86330c22a6c137d6c18077bd7db2ef1b290e"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end
