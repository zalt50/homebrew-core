class Gocheat < Formula
  desc "TUI Cheatsheet for keybindings, hotkeys and more"
  homepage "https://github.com/Achno/gocheat"
  url "https://github.com/Achno/gocheat/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "338e7123411c4a5fb9fe387f7155f1e48d511845fe7f2383718d16abf54b26fc"
  license "MIT"
  head "https://github.com/Achno/gocheat.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # failed with Linux CI, `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gocheat", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Description : keybinding", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
