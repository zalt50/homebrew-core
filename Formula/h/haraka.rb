class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.2.1.tgz"
  sha256 "0353c12bfb8fbf541bab42c15ca7111c067bf43a8a47ff9772d0c98fa420cd88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61a8008c9c66794880fbbb017973cdad3a9a29cba6c335036e7af8a0aac4b2c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
