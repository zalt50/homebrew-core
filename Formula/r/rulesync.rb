class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.23.5.tgz"
  sha256 "6235c406af1d3a18566c529710c7c40b6f39aa4ee0c54ab846bbe03eb3fa5d35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b18acfbdd0ed8032c27fc4d408fdb7c8e10edc95e79ec6421e5a51553924728"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
