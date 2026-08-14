class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.11.0.tgz"
  sha256 "a5d63725da7bdd4b90b7bce494f006ccfeff0f43a2d4c3536a91a1c17f79a428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06f4906f31b00610257aa99230d2869dec77214979b5cc78786780d636fd5fcb"
    sha256 cellar: :any,                 arm64_sequoia: "06f4906f31b00610257aa99230d2869dec77214979b5cc78786780d636fd5fcb"
    sha256 cellar: :any,                 arm64_sonoma:  "06f4906f31b00610257aa99230d2869dec77214979b5cc78786780d636fd5fcb"
    sha256 cellar: :any,                 sonoma:        "cac8128e0ec4a22046ceea0edfac134471ca106b2a7d2194287247ffa3be32e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22d60f93aa7c003f10a46a81c9b8815e22f44431db1f92b35861137efd07be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2132746395ee211e50166e1acd61a0bb4915af559bf0bc8595131cbee47e2632"
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
