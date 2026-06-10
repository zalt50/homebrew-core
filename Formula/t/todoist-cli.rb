class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.73.2.tgz"
  sha256 "2a0999166b78bfd43ede2b98348a5935b492e8e5fd7a0a832834d97698e49024"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4a23c4cd7c4db869ee30216b2a30e1fdf4b51b1a7a1b855e396208c61136609"
    sha256 cellar: :any,                 arm64_sequoia: "15acf02a27f1b1e8cef3cfe3e74a4031ca119384bdc9995267fda507ea671158"
    sha256 cellar: :any,                 arm64_sonoma:  "15acf02a27f1b1e8cef3cfe3e74a4031ca119384bdc9995267fda507ea671158"
    sha256 cellar: :any,                 sonoma:        "209ebbe06b295dff88cc48f0df68e02a6859afb210335a6d26303dcbdc67195e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a48d45826176363f3fdb0e4f2faaa042200af872c001235aebf4864b4386d08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e485b8fc06359ad4201b31c7b09393e67893755e2c718d559382d305e182de1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
