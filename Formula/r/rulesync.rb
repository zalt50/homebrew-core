class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.9.1.tgz"
  sha256 "8a12dc2b1ac49111ff69e46a230a6d0a718d7f44c2e12ae11915c9551864311b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45c8d6220791adae71fbf3fb556fb595a6b714b5a8e366f9060ac9fc6b9f7380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c8d6220791adae71fbf3fb556fb595a6b714b5a8e366f9060ac9fc6b9f7380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45c8d6220791adae71fbf3fb556fb595a6b714b5a8e366f9060ac9fc6b9f7380"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3c920ceb162e28e483654b62ec758ad8ccb47b281f3f170cf805e140c782c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3c920ceb162e28e483654b62ec758ad8ccb47b281f3f170cf805e140c782c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3c920ceb162e28e483654b62ec758ad8ccb47b281f3f170cf805e140c782c5"
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
