class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.2.0.tgz"
  sha256 "7c3fcc63708ba5a7270989ef76c3e969c538122773c9e3673d969c3f3bacc1f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7742f7fff43df57e2890b0b611e0c275fe9e48d4bd635c628a2c61df5b732fd"
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
