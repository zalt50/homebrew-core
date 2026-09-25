class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-17.1.0.tgz"
  sha256 "3738153e0756df2063a6a63c547a078c2b6de02635e963825e8c5d94728f92d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9276bdbc62ebe2d76385cda0bc37ab96475ea8cc25e070958ab85b8b7729476"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9276bdbc62ebe2d76385cda0bc37ab96475ea8cc25e070958ab85b8b7729476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9276bdbc62ebe2d76385cda0bc37ab96475ea8cc25e070958ab85b8b7729476"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e3848f82438a725f30877809dd046d6d7689deadf64376708c92b2ce8054dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8e3848f82438a725f30877809dd046d6d7689deadf64376708c92b2ce8054dfc"
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
