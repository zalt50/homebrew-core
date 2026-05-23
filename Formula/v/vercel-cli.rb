class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.4.1.tgz"
  sha256 "375b30d1be8b1b98d5fd4d3293b99d83d0b256f56584182f79955bb95c6f844c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf63adb4b7552f45e22afa4cd1146b591a30f22bef1c71351bd1c5839d7023c1"
    sha256 cellar: :any,                 arm64_sequoia: "4abfb0e3d9596cdfe328bbf203aca53d5b5f2ca99a00f0013e3b6ef7c80da7c8"
    sha256 cellar: :any,                 arm64_sonoma:  "4abfb0e3d9596cdfe328bbf203aca53d5b5f2ca99a00f0013e3b6ef7c80da7c8"
    sha256 cellar: :any,                 sonoma:        "a293ad18c30a787febb63b58476a8929d49175e63a252ef22a8ad43a9ab0e77f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ddacca5e05aa9f2f8f2170ff900896920eb6f45828365617c66a0b940bd588b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e5a4199d6f74d0f304cf14d09bd01f96c5d476a7bf168577016e2c0f42b471"
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
