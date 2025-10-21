class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.12.tgz"
  sha256 "fa49ff0ff19a68678c0f8a9c08f9f6977fceaf9400e9c2cf78b634ded2bbd420"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3fd97b4923acbbdc123ed0e7b5fd4c23b01fb9be820b07fa2c18ae4f590d8c35"
    sha256                               arm64_sequoia: "3fd97b4923acbbdc123ed0e7b5fd4c23b01fb9be820b07fa2c18ae4f590d8c35"
    sha256                               arm64_sonoma:  "3fd97b4923acbbdc123ed0e7b5fd4c23b01fb9be820b07fa2c18ae4f590d8c35"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d368d41920e17c57d2c47732bafbfd2ef0280b71cb7db67bf0c79525e85954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bff18cf55c83f0445848a37b3dcd7aec042d12644cead37479e11bf52f56b225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5309c56752a02f7cbf18d8da1f8ce02352fcc37b6989064a1b7e4079589a6aac"
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
