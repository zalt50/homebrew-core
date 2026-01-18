class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "8c77ab35fe00209e8adb960dbeeb95fe0f48114ba37782b1cc19ba82f1b3c0c5"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ee3d52adaefa29a3e8843d7f346d70050f83328e1ae2b47b37892da58c8141e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee3d52adaefa29a3e8843d7f346d70050f83328e1ae2b47b37892da58c8141e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee3d52adaefa29a3e8843d7f346d70050f83328e1ae2b47b37892da58c8141e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8abe6d1005193c0a643e30cf84d0fedf858245115717cec98cbea6fe3019bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c35662b055db869ace3bcbd14bbac61ce85af20690f3bb608afa56082de0741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d677de8963f68bbb63d895496ab118d7d798f17d1983a4bae717deb540e4d3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def shell_output_with_tty(cmd)
    return shell_output(cmd) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1")
  end
end
