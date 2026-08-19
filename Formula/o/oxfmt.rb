class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.64.0.tgz"
  sha256 "aa82b56a175292ba25bf02e893500452bec12a2c58b1b9372e5479c82b1ff29c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32426ae67f7ca8374d9f7d1b89a66c455c3c48af28c5037d382a80f1978046aa"
    sha256 cellar: :any,                 arm64_sequoia: "32426ae67f7ca8374d9f7d1b89a66c455c3c48af28c5037d382a80f1978046aa"
    sha256 cellar: :any,                 arm64_sonoma:  "32426ae67f7ca8374d9f7d1b89a66c455c3c48af28c5037d382a80f1978046aa"
    sha256 cellar: :any,                 sonoma:        "3355fdde105b4266f294620ba375b55808aed8eece8e6625c53be864efa5f737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d32c6c30b70f7dd328b31d8ca7eca6478dda8792453153acc480b8d5a7aafd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9528ac13cbfee4f7b0589e35037a281a08158ee6def449004ffddf10bc806c66"
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
