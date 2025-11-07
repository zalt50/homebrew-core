class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-13.1.0.tgz"
  sha256 "66382d10e91e06bb0b372b6a10312eb348c42ac45b39eaaa0af0382d765b4216"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85fef6c273b01f0dbbccd45e0b76008832fddbdfe6fdfd402e672eb751bb208c"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
