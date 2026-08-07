class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.7.1.tgz"
  sha256 "83dd6802124152fc64d475b7a60ecbef28f11bd7abb23c0d45d8b9e5db354f69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f32465986f579160fb52c6ab422c5f5f59f858c70f461508cf67a66ec99a3915"
    sha256 cellar: :any,                 arm64_sequoia: "f32465986f579160fb52c6ab422c5f5f59f858c70f461508cf67a66ec99a3915"
    sha256 cellar: :any,                 arm64_sonoma:  "f32465986f579160fb52c6ab422c5f5f59f858c70f461508cf67a66ec99a3915"
    sha256 cellar: :any,                 sonoma:        "40caca7efb3aa6643bcedbbbf8606fef6d07072c0ac17a2438ef3a36486403f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02dc6eb8e57c674ef4692d19ff42f000492247b77587eb4ca96fb882e1db9309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee470dad57c4288afafefb4cc62e04c628078640e0ff3fd3ca8686a34a20418"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

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
