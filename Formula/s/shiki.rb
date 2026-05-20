class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.1.0.tgz"
  sha256 "42a971c31e0dbeb75d4f90867964623d825032adbd7e0aee82e4c3ffffddf8d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4982b6dca9dac0148a63f697a8540a5c57609f364b9aa88c6645c80adff13477"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end
