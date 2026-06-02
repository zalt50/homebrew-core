class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.7.0.tgz"
  sha256 "561442deef47a2dd1f8c9e3917d9b69ec132ca23f66f34e7b7538132291dedca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0cd0025146394f964154a0cd77de5c4f31d4afaf4faa50e49f52cd9029af1d34"
    sha256 cellar: :any,                 arm64_sequoia: "5782609da5ae6adedaa513db34b8acd80f6a9a58563d88ea71c4e29d7419ebdb"
    sha256 cellar: :any,                 arm64_sonoma:  "5782609da5ae6adedaa513db34b8acd80f6a9a58563d88ea71c4e29d7419ebdb"
    sha256 cellar: :any,                 sonoma:        "0bcef7b20f409b879840e3927f21bf2bb94128dcde43a214f7e2eb9fb970e135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d841cc096941d2c77b285c494e7d252bc004c623fc3d2ff86aa75c8d53f04e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774822bc2daa26ff3532d460ab8190949b34681122e79383533e30ebcf1c5851"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
