class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "38fb3321111fb67dcf7a4218c4aeede795bee8168f3f4e8f59a5234629e896da"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0adb2ab62c186e247a7f562e0fdf5e084539e1bab03e4f8f3bf44a187691cfc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e40268979027a22f020d232fae47353ca7ec2ff944bc82c6740e5a234de7b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd199f0f1df97200877cbf20a8b872b36a0acecb143f5a4bb66833c021b42c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4426bdf3d796622cd37ca9acb712510c8cdbc11e804915c38f75c1d88f6f228"
    sha256 cellar: :any,                 arm64_linux:   "cf5c6cef570b2dee7b8be38735ce5bcf5d844cf3de42a233aea13065fc7e852d"
    sha256 cellar: :any,                 x86_64_linux:  "d09afa52e6eaf12b1bfeb3ca229b68441b788592a62286e82aa39d080abc71f5"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    ENV["VERGEN_GIT_DESCRIBE"] = "v#{version}"

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
