class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.4.1.tgz"
  sha256 "18a867f47b84bb57f795af1432dda1d8bd89fc440ec32494caa26e22292eb374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "202130282ae49d9d7793fce3a029d1caa5099e000bbd2f426351377e4449c2b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
