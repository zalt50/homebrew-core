class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.13.0.tgz"
  sha256 "bf0ce84c2c4338770d9e9dd403e7fd1e68c105f0e0ee16cedc56a530dda782b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63be35319239f85bef47f2ff086eb087e49d07f6ef857195abe0c394e8e523c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63be35319239f85bef47f2ff086eb087e49d07f6ef857195abe0c394e8e523c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63be35319239f85bef47f2ff086eb087e49d07f6ef857195abe0c394e8e523c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d324d95c31939f3155cfba9a09e2083872ddae889dcc48fd8390b15e7c1fb5e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d324d95c31939f3155cfba9a09e2083872ddae889dcc48fd8390b15e7c1fb5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d324d95c31939f3155cfba9a09e2083872ddae889dcc48fd8390b15e7c1fb5e0"
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
