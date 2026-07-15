class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.7.0.tgz"
  sha256 "cf125f3eea1c0e0ec52e536adda5eab9564a9e27b26797ac8f58019052b25535"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8dde249f05786238a163e9081d28b8b46e33d110e5fe5a96cb250352dc4b8cc8"
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
