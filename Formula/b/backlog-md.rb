class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.20.0.tgz"
  sha256 "c5592b01af170836a69237b167bec9165dd918ca23a72385dfa99e6e3757ec70"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "329d0eccb56f276b706ed8a6ab43997325ef7bbd987a084ea27658884df2d229"
    sha256                               arm64_sequoia: "329d0eccb56f276b706ed8a6ab43997325ef7bbd987a084ea27658884df2d229"
    sha256                               arm64_sonoma:  "329d0eccb56f276b706ed8a6ab43997325ef7bbd987a084ea27658884df2d229"
    sha256 cellar: :any_skip_relocation, sonoma:        "a04db3d2aba032ab0763564a6431b99e1b08b51c5bbca832be38a542034d93b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35307f437af8ee6435f316634bbad7475a02cce5730fa54834442a0d0548ff3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2d2cc3233a99641ffca24f102d7928390b11fb809a4fe426d5a2f35059922c"
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
