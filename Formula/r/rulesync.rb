class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.5.0.tgz"
  sha256 "6a44a35688de9454cfdde9408d1e935bf2b479536f2ee2a1ec30d56dde674da6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16e0e357872d825ef288fc8ca4c8f2420b21a2065e60dbb9dc666f6bf7fd7b67"
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
