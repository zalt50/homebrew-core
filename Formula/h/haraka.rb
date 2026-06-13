class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.3.1.tgz"
  sha256 "166892144098305a12ec1fd1d6d06e077a10c7adf0926e3baca049f24f675e4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb194d85395c0db1ac4bc7c6e8203473382d8668b76c0ea53189380743672978"
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
