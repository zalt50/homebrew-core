class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.37.tgz"
  sha256 "fa90db2f3da42e6f53de1bbd3b27e7397de98b70114b8b92c8ab44e17f22e153"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "005efcc0f8cbb3f303d6026dac8447daf43956821a076aa0eb63263de899de40"
    sha256                               arm64_sequoia: "005efcc0f8cbb3f303d6026dac8447daf43956821a076aa0eb63263de899de40"
    sha256                               arm64_sonoma:  "005efcc0f8cbb3f303d6026dac8447daf43956821a076aa0eb63263de899de40"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a2e201a67b655077f45a4bcc56363615e912b985f5901accd27f33349653e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12eda5bfb15092e8cb57c00c1663fcf13959b7391b10139eff71f68012ff5296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9a2bd43adda341536be0fe2517623e5c23dcc368fbe6714b7ff38565938adf"
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
