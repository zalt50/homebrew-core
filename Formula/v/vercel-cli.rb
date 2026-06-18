class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.14.2.tgz"
  sha256 "9e7a91ad5c30e86779cb32f12d5b30aaab81d99f0c45545d8795633eb8b32674"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1fd4d73c81110db7256376b97814b6a8725f3e1ad2ac612b5ad21e845fa710d"
    sha256 cellar: :any,                 arm64_sequoia: "d6c8c2cbc38a83b9ab1a5b734612df84d28a87a0292edbb3252ce9dc6f0a2c3e"
    sha256 cellar: :any,                 arm64_sonoma:  "d6c8c2cbc38a83b9ab1a5b734612df84d28a87a0292edbb3252ce9dc6f0a2c3e"
    sha256 cellar: :any,                 sonoma:        "049ff24022bd819e73316cb5713fdd4bcc5b25f21ebadd413046414dc0e0950a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833bbd2b14daebc07b0e25895fe2589fb3fd75c28c83722f4f8543360ee9c2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c53d9a61b174f453e16589208e2a714f5752cff41a4c4cc7390c70ac17616f"
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
