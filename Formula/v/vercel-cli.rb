class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.10.0.tgz"
  sha256 "7f56fc6c2f4657d2e74fd759ff8440f7ee4468ec974dcf9f2144e29093f5e475"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98d3f37e05f3c2d7e405ff09f9c82e64e637d6dbf6bcaefe74e0b8c938a99b7d"
    sha256 cellar: :any,                 arm64_sequoia: "091f76aff74ef3f03f66056cba138f6c7c23252e36fd868f7ab55c07e2fcd7ba"
    sha256 cellar: :any,                 arm64_sonoma:  "091f76aff74ef3f03f66056cba138f6c7c23252e36fd868f7ab55c07e2fcd7ba"
    sha256 cellar: :any,                 sonoma:        "28dfd01c0a3721a7bce4444d94c0c43de0581de4e85ac9ad43b6b29d2b72477c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5570fe55e9ee4c0b2cedc0199ea5a7a3cb402e8fe3869ec5854b5bfea9967d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d45755cfa85895a3796e7953a2a61aaa8c336d285132579860e8047b2c4728f"
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
