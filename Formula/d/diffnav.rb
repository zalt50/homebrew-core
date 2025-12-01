class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a38552e6cc71100a65fd6a72b1e210c50a0cb16e12d7c2a4693f41b81cd9d3c7"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  depends_on "go" => :build
  depends_on "git-delta"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/No (diff|input provided), exiting/, shell_output("#{bin}/diffnav 2>&1"))

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test.txt").append_lines("Hello, diffnav!")

    r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
    sleep 1
    w.write "q"
    assert_match "test.txt", r.read
  rescue Errno::EIO
    # GNU/Linux raises EIO when read is done on closed pty
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
