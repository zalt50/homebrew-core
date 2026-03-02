class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.11.0.tgz"
  sha256 "2561691677bcb29135bfc2f9db365030b182340fe87c2884a039de08424b7e42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89a787a0a289ade6bd7ec0b00fb23f422198d0151136ecca35d7875d3c42c35d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
