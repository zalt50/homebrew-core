class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "c1b3d029b6d6b852903d6ffb0c7aeb9d93450aaa4099ca2c285518475a211f8b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "181b490924e84ba09be244d7ce94de1a49d1671bff5a70a6b0185ef0c18a8261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f56173043415bdc18a35e1dbb7511f6c1b1da95a77dd8b7963a2f43f6a09bddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c4922b866ba9b992a7fa380d80ffc123edd4e1f8ff567cca91f2a27c06db0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "971339e082df172a8e560ae711ca12d74852672cc00add5d15de76fcedfde5b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79299653ea1ac2db3261d061521e715fec92ae67c87a2088612ad86580dbc870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab35f18b346d493c8b932a5e903119bf0f6ce1519c9a0b9463b3c1bbe03f5a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end
