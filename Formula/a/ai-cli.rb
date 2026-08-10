class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.4.3.tgz"
  sha256 "0f8a8c96bdb194ed01f08eb83e1f0a692f508d7a45dab202343ee41fd71760c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eda295807aafeba48ac65a30afa500eabe3c82f018f56d72d72cd7fbb97244c4"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
