class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.95.1.tgz"
  sha256 "a9365f60df8b4e5d92952b097cf9011ca63ad0c5cdd7e99686e76f2620e04664"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3a191cb3021ee7af3bf1cae58578d8653385883a35ea042b22f8e2456fde29e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a191cb3021ee7af3bf1cae58578d8653385883a35ea042b22f8e2456fde29e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a191cb3021ee7af3bf1cae58578d8653385883a35ea042b22f8e2456fde29e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea67c0d3182c49c338cf545d19d63731b09cef92319d67d15259ec76f0733ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5042e4ca85468b519b96903a97d7572964ca356952490def2b81f669496554c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebc2d8bc38818a52a1179c8c89445997fe51373778c0a261640301e4085bbc5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
