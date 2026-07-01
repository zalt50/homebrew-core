class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.4.1.tgz"
  sha256 "85f4badd522e08577ac7f19909a068ce87431c695f14316d449e99eb59523f46"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "43cf6382d9d24b81ca47718f89722691ef8b14bcc4e86b7b7fe527e24ec1199c"
    sha256 cellar: :any, arm64_sequoia: "5d040b740b5bbb38fd9e43e6b57c39f91f4e35243e13b530a0ca35267b5c1eee"
    sha256 cellar: :any, arm64_sonoma:  "5d040b740b5bbb38fd9e43e6b57c39f91f4e35243e13b530a0ca35267b5c1eee"
    sha256 cellar: :any, sonoma:        "ab0940ad87c25d4d5b93f97b5ffcff6bb16af2ff7df20d794435ebebda6b7634"
    sha256 cellar: :any, arm64_linux:   "4494092383154b4c70798072a8e3926057b27bb46a2a080c793b927f6bdca858"
    sha256 cellar: :any, x86_64_linux:  "552ce39089d04ee06715a8e220839469387bcada877ea29005afaa41a9096398"
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
