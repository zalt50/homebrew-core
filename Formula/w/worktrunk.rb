class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "51f095a2f492b7334ddcaa7c17630b6a04be29fa6186f5a6182088d98060f3c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9167718ad732d32ebd9e2c2ae29ba5d28b052750302204184b4217a52ae65a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c2c506936fef44c5d834c2f0a855f41980ac00f9945b1f298ded574c1f702d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e51ffaf1bc961e8c9f68cf525b068375d7d4163e60cf38136e46a6f4c9f531"
    sha256 cellar: :any_skip_relocation, sonoma:        "0daf7905b7042e3e46ed2b5f51dbf3ced3b50be9f0991da9e7c11850ad99a6e4"
    sha256 cellar: :any,                 arm64_linux:   "d7f549b2752f6fd1dea69a4d79fccbcbe50ee694013f07fb69fe1fd9a272e9df"
    sha256 cellar: :any,                 x86_64_linux:  "0d889cafa7ffef77e71f56ff4131df4f047954fd5542001f134affc6969b5dd5"
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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end
