class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.40.0.tgz"
  sha256 "a0188388c7aebbcbe4a179c5e2295f4881757c1ae8e6ce3ab1938d64e48d71ab"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "09672ee449d5dbd0fb590965bb48989afabc005f6183f78301cfea3915a52442"
    sha256                               arm64_sequoia: "09672ee449d5dbd0fb590965bb48989afabc005f6183f78301cfea3915a52442"
    sha256                               arm64_sonoma:  "09672ee449d5dbd0fb590965bb48989afabc005f6183f78301cfea3915a52442"
    sha256 cellar: :any_skip_relocation, sonoma:        "f12e3e5e5c3264e9149ec5d43309664835cb9be74c627bf00488c0454d3575de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8ce000ce7e5a7bcbcf1412fc26e4924facde3b7e47f199539d1f7c046c20d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cf8a4d406aea30b72d4ec886f8f425f3b6f05187222f9ffe212468df9278a57"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
