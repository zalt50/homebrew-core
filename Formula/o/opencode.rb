class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.28.tgz"
  sha256 "a1162a3d723dbcb8f9353fc8b718bc85d5e255b59493bee4d8035a02f9ab6fb6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c589bb8b0f8028ce0887eb15f270a88cf3c6e97c4e6448c421e98d6985b97cec"
    sha256                               arm64_sequoia: "c589bb8b0f8028ce0887eb15f270a88cf3c6e97c4e6448c421e98d6985b97cec"
    sha256                               arm64_sonoma:  "c589bb8b0f8028ce0887eb15f270a88cf3c6e97c4e6448c421e98d6985b97cec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f604989f45652097bf7265c19e766b83baff48937d4f670a53698cd06c75cf2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9db5db4849ba7378711634f82ded544880e6c766fb2468edafb0a15e4c845f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e32dfc5625d584476eb31d0e4f6d62e16969929f077b904c91deec62de3aa0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
