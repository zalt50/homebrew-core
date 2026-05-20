class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.4.tgz"
  sha256 "7ae4f8e64589a1b7569dc27398870b12251a688023876b10f58d4a3d8502b40c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ebc3a3658622fd26e9360b49ec9a1e2d4e412afcd4c4b75ffeda08bc80917dd"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.json"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
