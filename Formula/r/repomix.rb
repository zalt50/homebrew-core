class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://repomix.com"
  url "https://registry.npmjs.org/repomix/-/repomix-1.17.0.tgz"
  sha256 "d85b881c5ca62d5eb8397a2617529e3b43dd0e1c40564ce83a5c286b767651d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "270271a36d83aa65a4721e0a87a11c85d2cfe162703be17e1de36c3a7563a88e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
