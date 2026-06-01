class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.5.tgz"
  sha256 "f0144a9738e901fa69e9b40ac40f69049151d1b8ee449304ee7d9cfd0b00f0ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84988b767b9efbcdfccfdc65368eaa20a005d4deed9643531ec44945a939d9a4"
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
