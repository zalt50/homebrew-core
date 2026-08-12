class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.3.tgz"
  sha256 "aae4f3e7bf3bd5f75b78a6bd1851993c534bd91f27bdcb109b06afbbb2c52428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53d08fa4c405c9625a0225966ad11fb6cfc09c5fb16ad27cfd25f12f0172bc48"
    sha256 cellar: :any,                 arm64_sequoia: "53d08fa4c405c9625a0225966ad11fb6cfc09c5fb16ad27cfd25f12f0172bc48"
    sha256 cellar: :any,                 arm64_sonoma:  "53d08fa4c405c9625a0225966ad11fb6cfc09c5fb16ad27cfd25f12f0172bc48"
    sha256 cellar: :any,                 sonoma:        "e0e12ae36c78b64548309690b806dee13553ad4b96d03d49a943849f34a63f8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ad6581a559b56f446e148a039871ed32e3d9fc0055eb302b334efa63345293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b1952d9f163cc50d9224db9c9e0cd24c0ab873b7181af2e27f74f072343c08"
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
