class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.36.0.tgz"
  sha256 "f51c3b9c9243302517c9eb7d09a598a9b2693f1ec09b035c3272a5fc6a186fb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "560edd40cb763243bc7474277ccdd6d3fd26d493bcd609f42f0f3a7069dfb7f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "560edd40cb763243bc7474277ccdd6d3fd26d493bcd609f42f0f3a7069dfb7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "560edd40cb763243bc7474277ccdd6d3fd26d493bcd609f42f0f3a7069dfb7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7c82e9fc78cc451d23e42fdfbe3cd3238763e6ac65f6061a2c556fad7cdce87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f7c82e9fc78cc451d23e42fdfbe3cd3238763e6ac65f6061a2c556fad7cdce87"
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
