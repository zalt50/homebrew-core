class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.6.0.tgz"
  sha256 "c837d1fde4ee850914e3a2bb34fd4ef15c863ae1087d7c3933fdc6afcc06e24d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61c2a62b9b8e950150a96e92a2b5d6e355637e4d7c524f9f769e05b7dff795bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c2a62b9b8e950150a96e92a2b5d6e355637e4d7c524f9f769e05b7dff795bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c2a62b9b8e950150a96e92a2b5d6e355637e4d7c524f9f769e05b7dff795bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2995da6add845830ac29861d1e185c1c902cabe655e02f7be0657af9bf8cba3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2995da6add845830ac29861d1e185c1c902cabe655e02f7be0657af9bf8cba3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2995da6add845830ac29861d1e185c1c902cabe655e02f7be0657af9bf8cba3d"
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
