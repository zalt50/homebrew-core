class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.30.0.tgz"
  sha256 "237db27b76cd14f1b8974d57ecbcd73bcfce7f4fccee415eb98763e587fdbf5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e54bcaabf7a113d066d574209fbdc2cd66718b5b3e74d634083f4e40761e808"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e54bcaabf7a113d066d574209fbdc2cd66718b5b3e74d634083f4e40761e808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e54bcaabf7a113d066d574209fbdc2cd66718b5b3e74d634083f4e40761e808"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08d0ee0aa353e745fdd10cb7508a4ecbdeb9400e795650da950f71c009e7ab50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "08d0ee0aa353e745fdd10cb7508a4ecbdeb9400e795650da950f71c009e7ab50"
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
