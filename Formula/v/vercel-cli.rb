class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.4.tgz"
  sha256 "7b2db3d80f135c81c170d11b2a8349cde4352603340a2f6d5358da4161e055f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "416ef39467c90eb20bdf9fe1fbc8a972a5f02ebd12858f6a7e4e1ef8a65948f5"
    sha256 cellar: :any,                 arm64_sequoia: "4af8dd1656ff60b0804b39cd0d572cfa8e1d9403ff1f6e2bd71e6f7402ddd99e"
    sha256 cellar: :any,                 arm64_sonoma:  "4af8dd1656ff60b0804b39cd0d572cfa8e1d9403ff1f6e2bd71e6f7402ddd99e"
    sha256 cellar: :any,                 sonoma:        "20b154a68d83be653df8efbbd8f6597adba1aaea3c5a4801c1b57881fc149521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1762f4859547cc7c7c71e2fae7afc890d86ed372bb38124f358cfbbaef7af4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b52ab6fcdc58e19cb7e5397b9006d3caca8225e294c5aa6f9f12f12fde6adec"
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
