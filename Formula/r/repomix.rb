class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://repomix.com"
  url "https://registry.npmjs.org/repomix/-/repomix-1.18.0.tgz"
  sha256 "4fa03e3d57a617467ad03505523419700863e1fbfdf432b31d78eeb38dc0036f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9dcdee573fd934fdd5f26b2707b87dd3a8dd905f4669931afc64290bcd9c975b"
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
