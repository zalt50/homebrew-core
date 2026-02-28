class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-7.0.0.tgz"
  sha256 "4ca52e401088fd3931bdb99fd7fa14b0a03a2edb9bf1949eb368e41871b2d86a"
  license "BSD-2-Clause"
  head "https://github.com/yeoman/yo.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Couldn't find any generators", shell_output("#{bin}/yo --generators")
    assert_match "Running sanity checks on your system", shell_output("#{bin}/yo doctor")
  end
end
