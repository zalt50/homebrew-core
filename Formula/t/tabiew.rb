class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "88876174a3a008618e5b2a55df5dffa26cc0593ce2dcf6b057900ffc303732a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e08204952d5664bd02c981bc5d6d1a4c21d6ee69d986a1baa53b00ef781f4a5"
    sha256 cellar: :any, arm64_sequoia: "08725701e4ee397bf84428103f31d44064a88f2f30378f61085d75bff82c8edc"
    sha256 cellar: :any, arm64_sonoma:  "aea1502321a209adab0c8d385d65bc9feb61002b245694d64003e7369d45c930"
    sha256 cellar: :any, sonoma:        "025c63768b0c88f7c76e0d5d6c3d29bc02db00a4ddd1f274334ce7005170aa15"
    sha256 cellar: :any, arm64_linux:   "7bb4aa6ea6572a05296d0d809ef938654101f4897e284a35c18b83627bc31a4f"
    sha256 cellar: :any, x86_64_linux:  "0228d3bb2cb0ea2aa6633b797a07b26f6a286226d05e2675b655edd9e23bdabb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash" => "tw"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tw --version")

    (testpath/"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV

    require "pty"
    require "expect"
    require "io/console"

    PTY.spawn(bin/"tw", testpath/"test.csv") do |r, w, pid|
      r.winsize = [80, 130]
      r.set_encoding("UTF-8")
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
      w.write "\e[1;1R\r"
      refute_nil r.expect("you think?", 30), "expected the CSV to render"
      w.write ":Query\r"
      w.write "select wait from test where tide < 40\r"
      refute_nil r.expect("you think?", 10), "expected the query result"
      sleep 1
      w.write ":Quit\r"
      w.close
      r.close
    ensure
      Process.kill "KILL", pid
      Process.wait pid
    end
  end
end
