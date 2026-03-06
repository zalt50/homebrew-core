class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.15.1.tgz"
  sha256 "0d230e97d22ed21a05547e131ee81ebfd2f8e8c92d5daaf21d75921a32dbf098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3849e70db7d8e06a18942129259b0c52328c58028664c0efdef2c7d0b8ac6255"
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
