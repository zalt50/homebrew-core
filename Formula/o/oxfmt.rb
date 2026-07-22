class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.60.0.tgz"
  sha256 "b4926144444c6282fdad21f8a9dc8d8d183c863f104a4a35e82c5867187ecf9c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fda28560b6a19f984fb6c67a432b2857c55a63c5db39aeb357b76722628ccd87"
    sha256 cellar: :any,                 arm64_sequoia: "fda28560b6a19f984fb6c67a432b2857c55a63c5db39aeb357b76722628ccd87"
    sha256 cellar: :any,                 arm64_sonoma:  "fda28560b6a19f984fb6c67a432b2857c55a63c5db39aeb357b76722628ccd87"
    sha256 cellar: :any,                 sonoma:        "a794efeb5c5e9df769cfccaa7e1f4269538d53fd0971f75e66d735dc0cd8a63c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7497b6d2a219bb22663025cf1ca36c854c135a2f1d75aa04b52e2d2dc68e46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0553c5dadc12bb20d87997c8bf3e730a8bd7142c593048e5108694639ec38cf6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
