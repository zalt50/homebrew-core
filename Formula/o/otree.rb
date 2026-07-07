class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "4614dc618c87782639606973d262f9b4b5fd58987e3510dab8ad6074d6a8cb69"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11b11458f542018081d314d39e7934428194e8dd7071cdb101195c2a02c8a48e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188c1f33c5b356bfe5842064bd39d5503c77d6636836d72ef5e61c8c12c927a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4751462303a9b10468b312d9192ea461d6bccf3e2e52a2e0c7b2c9f02163c66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "362652bd65c1d1bc9d1e810deedafc2341b9bab3dbf0df9ff00d50a6aadca08f"
    sha256 cellar: :any,                 arm64_linux:   "5042b5d0a6d2de189caa645b2062e533a495255164053d0e59face076de46255"
    sha256 cellar: :any,                 x86_64_linux:  "0e1db7f844583fe8186ec62501132ae731e0a2936efe9e33554754c4326a1f63"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
