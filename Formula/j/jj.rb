class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "af0513ed0f1d6aa1c6ee83cd5432f6e77db8f7c7ac1b7244612f1e26895688a0"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c6ec05918cba1baaddfa0a3eaf835cfaa49a4dccb1b755f16873629accdc905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512e1542b416eeecdb58d355c8b59053b2b6c413aee6567926db305c10187da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "325f6b132749ca1a97f666fc7b16158a2ee7c38ae85eb236c6c5dd927a34e69c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9260cf1471a1cbbd4a11a56e8b867450905d40e46f4db99458eeb3d70a160e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db3135f3f79acab866b8f186ac2d13e49ca8495f792790249461e34faa7aa406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e634ac7cb9964ac2b4835b03b9f0d5878d9501694438990fa3e880867182f89"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
