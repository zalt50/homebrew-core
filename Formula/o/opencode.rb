class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.12.tgz"
  sha256 "04c016a652e642bc6d4b4f41c4d605d8421b0b3dc5d3a698c84c54019c6d906a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4142b2ee26d72df3bd133240b4d15de2e396809b1715ad76e4dcb2d8307adbe8"
    sha256                               arm64_sequoia: "4142b2ee26d72df3bd133240b4d15de2e396809b1715ad76e4dcb2d8307adbe8"
    sha256                               arm64_sonoma:  "4142b2ee26d72df3bd133240b4d15de2e396809b1715ad76e4dcb2d8307adbe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ae8b938ac652003f0bd275c73e1dd867b54bbb3e128e3e987be42e6d29c82aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "380a17f1686ed648f15467f8b4a2046cd1cbc20547af44267ccc58f82c6aaa94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1311a229c3d096b0b144e9dd12ae90a85847048e5f873142659011c3394996d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
