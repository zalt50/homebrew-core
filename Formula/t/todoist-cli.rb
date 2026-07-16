class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-2.0.1.tgz"
  sha256 "0a92fd6ba915424fbaa1c853b56a98cac527217256b7014697aff9787ea85315"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f3b4ee1b0b104b5ae297b0496d839c8de3ef66fc8f9ca1e112b5b9254bfdb14"
    sha256 cellar: :any,                 arm64_sequoia: "7f3b4ee1b0b104b5ae297b0496d839c8de3ef66fc8f9ca1e112b5b9254bfdb14"
    sha256 cellar: :any,                 arm64_sonoma:  "7f3b4ee1b0b104b5ae297b0496d839c8de3ef66fc8f9ca1e112b5b9254bfdb14"
    sha256 cellar: :any,                 sonoma:        "e29c73e407049476bfeeb2bf4d5da690802e38be6828a1d8f2b1bfdb6b05d619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fbe7938e9d58035ae0ff6feea948eabdd0af015fca903a9b973e256cbaffff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc9e6a70598df0d3e92e57cf0d47041d8c264564f899ae91cf17a970f916f15"
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
