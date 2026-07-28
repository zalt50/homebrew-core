class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.61.0.tgz"
  sha256 "e48e64e9b14fa67a5197c87866136f4f0c3e155b762b67d40d0cf74c0b3867ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e06f8b0213f7ba939b2349b9d111579e92e0c2dee95d26b2951a2e69c0aa9eb9"
    sha256 cellar: :any,                 arm64_sequoia: "e06f8b0213f7ba939b2349b9d111579e92e0c2dee95d26b2951a2e69c0aa9eb9"
    sha256 cellar: :any,                 arm64_sonoma:  "e06f8b0213f7ba939b2349b9d111579e92e0c2dee95d26b2951a2e69c0aa9eb9"
    sha256 cellar: :any,                 sonoma:        "d12d5694e607b169d912a9e95c293577a3f4167d027218c788d8d69533f8971c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f20b77936a6fb9fc63710268de093ea39a5abc748af2c26d6aa6f035812565c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752e65e85565ee2566e0f34b15d5eabb284b11e86272c3bab6fe257e822ad77e"
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
