class Kibi < Formula
  desc "Text editor in ≤1024 lines of code, written in Rust"
  homepage "https://github.com/ilai-deutel/kibi"
  url "https://github.com/ilai-deutel/kibi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "086eeb4c9ffaae98c02c39d932796987590978b5907ed3e6ac5d44aeabec176c"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    PTY.spawn(bin/"kibi", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0013" # Ctrl + S
      sleep 1
      w.write "\u0011" # Ctrl + Q
      sleep 1
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    sleep 1
    assert_match "test data", (testpath/"test.txt").read
  end
end
