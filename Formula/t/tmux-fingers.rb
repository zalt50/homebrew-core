class TmuxFingers < Formula
  desc "Copy pasting in terminal with vimium/vimperator like hints"
  homepage "https://github.com/Morantron/tmux-fingers"
  url "https://github.com/Morantron/tmux-fingers/archive/refs/tags/2.7.1.tar.gz"
  sha256 "5e62f8550787842fc712203df31f7eaa723f7023ab19bc97d28b3b85e2d7c420"
  license "MIT"

  depends_on "crystal" => :build
  depends_on "bdw-gc"
  depends_on "pcre2"
  depends_on "tmux"

  def install
    system "shards", "build", "--release"
    bin.install "bin/tmux-fingers"
  end

  def caveats
    <<~EOS
      To initialize tmux-fingers add this to your tmux configuration file
      (~/.tmux.conf or $XDG_CONFIG_HOME/tmux/tmux.conf):
        run 'tmux-fingers load-config'
    EOS
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_STATE_HOME"] = testpath

    socket = testpath/"tmux.sock"
    system "tmux", "-f", File::NULL, "-S", socket, "new-session", "-d", "-s", "tmux-fingers-test"
    system "tmux", "-S", socket, "run-shell", "#{bin}/tmux-fingers load-config"
    assert_equal (bin/"tmux-fingers").to_s, shell_output("tmux -S #{socket} show-option -gv @fingers-cli").chomp
    assert_match version.to_s, shell_output("#{bin}/tmux-fingers version")
  end
end
