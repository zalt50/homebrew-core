class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.11.0.tgz"
  sha256 "94f2a9afbb9f16c16d2232d68ae011a12b57b48188072984c9172ce05a7ac415"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87065c67ee0b0fb5b32e6d72027f614374a7f8adff284f9e4f68b43bf60459b1"
    sha256 cellar: :any,                 arm64_sequoia: "a85a0ea2be3a7396da7918f6a573dab47cce0150b0092ce317358f7c9dc4bbdd"
    sha256 cellar: :any,                 arm64_sonoma:  "a85a0ea2be3a7396da7918f6a573dab47cce0150b0092ce317358f7c9dc4bbdd"
    sha256 cellar: :any,                 sonoma:        "7256e11119f4239ead87939b042cfa479e1a993bb5560a162ec4da7fa3c9315e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc77442f15f482a88eeb9ed582d93f687be76840f67315088f20fbd3305f315d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0166b1300e866d909cc206b34f52780c59290ee86ab74af612b58d82873dcbd"
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
