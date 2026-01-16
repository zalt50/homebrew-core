class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.29.5.tgz"
  sha256 "4c9f6a599034ca1df4230efc5c6025a56781a8f60a0df9d415af38a46800ce72"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b74279e67333c84ba676736e8d52171fb6560ba57f866df324ad6d2115604ab3"
    sha256                               arm64_sequoia: "b74279e67333c84ba676736e8d52171fb6560ba57f866df324ad6d2115604ab3"
    sha256                               arm64_sonoma:  "b74279e67333c84ba676736e8d52171fb6560ba57f866df324ad6d2115604ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "533f6b8cb9eab259a809eecb07b031727690df333a6dccdedc7570cda48aa684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f3247bf5029fcbe27fda935a977d452753bc3755d4778d24c374e0847e3c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc19e203b5a732971f58c6aec7a62fd00ae44d4757f86c163bbbbdfb9cee7a5"
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
