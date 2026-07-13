class Taproom < Formula
  desc "Interactive TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  stable do
    url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.2.tar.gz"
    sha256 "85ee7660bb76ed9277573d2c856bcfebd3181b919edf3862e7f9e15d32097088"

    # Fix version number
    patch do
      url "https://github.com/hzqtc/taproom/commit/a26afac788a5122356bf9c07c3c3d04fabae76d3.patch?full_index=1"
      sha256 "c9c5684f557ba7b3a5db9aee5b7c4a53bc41ac98f713aecd96afebd19ce1066f"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a4c21017c8cd7898958b03078c993e5f4275b18148e7f182ed224c41f4885e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a4c21017c8cd7898958b03078c993e5f4275b18148e7f182ed224c41f4885e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a4c21017c8cd7898958b03078c993e5f4275b18148e7f182ed224c41f4885e"
    sha256 cellar: :any_skip_relocation, sonoma:        "57bdb6268f1817d02feceb42f9c32f4ff03513089f8219d1e1dc0f6de859c22f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62900cb76de254441da1a112fcf62716aa017f45648b43c3f84ec3f465e5a68"
    sha256 cellar: :any,                 x86_64_linux:  "cd176204ae635eb6c73943610ef17f5edc46baea70fb74107cc39f3d2697945b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    require "pty"
    require "expect"

    # taproom is a full-screen Homebrew TUI. Launch it in a pseudo-terminal and
    # confirm it boots and renders its data-loading screen, then quit cleanly.
    # The loading task labels are drawn before any network response, so this
    # exercises the real UI without depending on network access in CI.
    PTY.spawn(bin/"taproom", "--hide-columns", "Size") do |r, w, pid|
      r.winsize = [80, 130]
      begin
        refute_nil r.expect("Loading all Formulae", 30), "taproom did not render its loading screen"
        w.write "q"
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when reading from a closed pty
      ensure
        r.close
        w.close
        Process.wait(pid)
      end
    end
  end
end
