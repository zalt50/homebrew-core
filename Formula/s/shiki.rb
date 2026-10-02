class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.5.0.tgz"
  sha256 "1e0abe72f8c477706f0c4fd82ff24af1feb8c34867695ddc03766ed5e5f8155f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0db45cfd857b97bc523101753b2d111f6c83ad748ac9914d5c4fb52ebae9d8f"
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
