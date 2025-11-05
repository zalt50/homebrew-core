class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.25.tgz"
  sha256 "8f172bd44d613e17087366c48c0e05aeed9f5c20813d9176bdfd1e7695e4130f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "302c419d649119633fe9c75b0b2928faafa1a4bb14c9226d0bdc140f669da9b9"
    sha256                               arm64_sequoia: "302c419d649119633fe9c75b0b2928faafa1a4bb14c9226d0bdc140f669da9b9"
    sha256                               arm64_sonoma:  "302c419d649119633fe9c75b0b2928faafa1a4bb14c9226d0bdc140f669da9b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c358f2b86c9c0733513165241595cd336877d29fe5d4819f9748286cf31e5d57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ea546132bd7177270c889a9be8c9bc303fbab41ea107ce7afa73891b6a9f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9740666180ea353a8c1d97de98c92b8a793686b4a9a715a8d98bd6474a6db111"
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
