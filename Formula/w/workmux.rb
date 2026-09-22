class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.265.tar.gz"
  sha256 "75357d6b1a9d58359d97b8ba3f6b65158eb7c05342c7a83802a7dd1690fdd34c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d425db64c7134fe96b65955e14918dac5721628912916a633ce5c3a8d4dc396c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7438603e001ac03c3a48c5a97ebfe2a2beb3ff5b45c04569c1ebd3fc39339307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "354908a66904ec8e6e1b03a5787df468023f8457d734e145b72f98f07aa15200"
    sha256 cellar: :any,                 arm64_linux:       "3ffbe44955bc8cd97214c93078d708c2f121e94a5bc2ec0c01178d6cfc0e79f0"
    sha256 cellar: :any,                 x86_64_linux:      "ad8369795fa7b325e63f198220fb901c5da68be8d268218e6bd0a32099ed3225"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"workmux", "completions")
  end

  test do
    socket = testpath/"tmux.sock"
    mkdir testpath/"repo" do
      system "git", "init"
      system "git", "-c", "user.name=brew", "-c", "user.email=brew@test", "commit", "--allow-empty", "-m", "init"
      system "tmux", "-S", socket, "new-session", "-d"
      ENV["TMUX"] = "#{socket},#{shell_output("tmux -S #{socket} display -p '\#{pid}'").chomp},0"

      assert_match "Successfully created worktree and tmux window", shell_output("#{bin}/workmux add brew-test")
      assert_equal (testpath/"repo__worktrees/brew-test").to_s, shell_output("#{bin}/workmux path brew-test").chomp
    ensure
      system "tmux", "-S", socket, "kill-server"
    end
  end
end
