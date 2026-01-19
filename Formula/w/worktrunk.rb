class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "6cfab083f258ac8c4f4b43a2a0c5980c169071b7a6252b52a932f478019a6039"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16e08f28ce01e597975590da6404aa2946300eddbc9f78da0fff2ad02e6a10c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95dac17af292f06d4d1338c0ac381f5d42cd22dde12c0b39fc445ff6c95e19d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db4b1e86d4e45678f3d4959f28a41186e84bd90f0cc4864e3881ee565db6b49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d94ef74e755a617fc420bd57b427a7e24bf264805d391b3587ab9f59aedf8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "effaa2b34e72ee94146e3c4a99c66d70f6044954294a54755c4f6ea0e32bc6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536125ffe9ee54eaf295cf07dd76320278886f8d9391a8250f8d5b0152b3b8cd"
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
