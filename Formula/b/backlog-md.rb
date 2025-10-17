class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.16.6.tgz"
  sha256 "645d3400137d570ad5cb44bc81db9ff815deebb1276c967c24d742fc9cdcf529"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "25831a18a4c79b9650f609023bf09677bc2bf5ae5bd2c92a4a5e8c689b0e27d4"
    sha256                               arm64_sequoia: "25831a18a4c79b9650f609023bf09677bc2bf5ae5bd2c92a4a5e8c689b0e27d4"
    sha256                               arm64_sonoma:  "25831a18a4c79b9650f609023bf09677bc2bf5ae5bd2c92a4a5e8c689b0e27d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5035842b52fbee304f12ddfb096d795b94b0b03538b047182a1b5d90e3c1ca0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f4f32c3295c7a03bd56d681d09ebb461edc06277a8e8a2fff592f0ecf87069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "131da8c6f779b442fba19492c097f54a15377a3c12c0a46c42510d5c29dc45b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
