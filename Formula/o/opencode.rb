class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.35.tgz"
  sha256 "bf552e5213aaae1f18c3274c16065cf98d350a08e295d48c5c4390e4eee9e4b3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "19d0c438be1c790fa95ecfc8907f25ea94209b3daca4cace50b3b4a54840d593"
    sha256                               arm64_sequoia: "19d0c438be1c790fa95ecfc8907f25ea94209b3daca4cace50b3b4a54840d593"
    sha256                               arm64_sonoma:  "19d0c438be1c790fa95ecfc8907f25ea94209b3daca4cace50b3b4a54840d593"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30ec6906069615afa47de9988c8e3dcd5c288690fb921cfa4d960474897fedd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142a8f14761dc20112eb9ed53a1935a66688829ac64b1b7eaffd4e9baf8de09d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1213442684b60cd292c1440b446e11651e321f83a71414ab29cd8b5edf6d7720"
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
