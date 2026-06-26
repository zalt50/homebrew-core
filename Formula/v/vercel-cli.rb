class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.17.2.tgz"
  sha256 "97b4b9ead6d49acde4e81e52c675d75907c375a45a5da5d23bb61ae5d71c6906"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "255cf82cb3cfaa0f9b1c00a5f97cc8bbacb5f1b2b0087aad89dbfe0424c88212"
    sha256 cellar: :any,                 arm64_sequoia: "296e99e251486801e078522093f75ee224df426ab9498f713cd2cee3add1982c"
    sha256 cellar: :any,                 arm64_sonoma:  "296e99e251486801e078522093f75ee224df426ab9498f713cd2cee3add1982c"
    sha256 cellar: :any,                 sonoma:        "2e042dc0b0085d5c1a8d106cd767c8e4a5819b656008d3cf72dc33a110eabd05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ff0f8f60589c90c60a01fda97f15b25bd4446995cf1908d125a4b7c3dee70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b71a7bf3d828301d06c6690d0fbf9671589eed781281fa9c3db4da65272bd1"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
