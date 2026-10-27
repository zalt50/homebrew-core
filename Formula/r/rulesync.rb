class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-42.0.0.tgz"
  sha256 "bf4cf9878bbbd4dcd8073dc012d4b5d611fbb1bf93ba1916b8e0a8d291c42942"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f667b059954c24bb8a6d54d170de5efd08f0589f109425b68855baa32a4e0eb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f667b059954c24bb8a6d54d170de5efd08f0589f109425b68855baa32a4e0eb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f667b059954c24bb8a6d54d170de5efd08f0589f109425b68855baa32a4e0eb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99129fb2c0000647bac54969935880f9df0d39824f8e7e52ea99477b0df0163a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "99129fb2c0000647bac54969935880f9df0d39824f8e7e52ea99477b0df0163a"
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
