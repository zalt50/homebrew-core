class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.25.0.tgz"
  sha256 "91df85521146f0a844b57f3fe5c6d8a0dae7fdcb6318d7e8dc4df57625c9bb3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53cdf6ff6e3389a9ebbc6454f10be76dd87377549529f50504823666c61d080d"
    sha256 cellar: :any,                 arm64_sequoia: "3afc1c51078249ef29a2b0ee11c64e393d2816412bd72fc4580bf7c6d607e87c"
    sha256 cellar: :any,                 arm64_sonoma:  "3afc1c51078249ef29a2b0ee11c64e393d2816412bd72fc4580bf7c6d607e87c"
    sha256 cellar: :any,                 sonoma:        "5c11cbebbf3f28a98fc4ef5a851d9ecd8d644e1d022960cd643e7e20733f17bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9511a610110bf09b4a4b71caec05e8bdbe4db050e2801368db10ba5f0e9ffc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80693ce69f74bc07d7b2e13ca4d0931584ac9111b4dd2df0a9db6433d8c561c8"
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
