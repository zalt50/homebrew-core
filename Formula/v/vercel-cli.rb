class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.20.0.tgz"
  sha256 "ad312d5ffe89e425ac82f21a8816475e6fe5bb7d8084d3eb2e186bbb1c8c9a9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9f0431e9870fecffcf6fa5b76f06ba6911b75bba7637ed8f5ffe6f6003943ac"
    sha256 cellar: :any,                 arm64_sequoia: "67521559a0fd53641a875a985251be308624017a023016e81e1e52f9fa037ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "67521559a0fd53641a875a985251be308624017a023016e81e1e52f9fa037ca7"
    sha256 cellar: :any,                 sonoma:        "12eaef3d90eac688cc18dcea4457476af7b2419e9cc447d2655642e426689422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e302396af6156bf90165ce487baf32ba1feb1eddb688e9fb8e05d398eeb3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa22398891dc67d3b5da41f8d591fa10460af3bc4d2e277aa5321e86774f0b2a"
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
