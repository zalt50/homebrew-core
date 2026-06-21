class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "a2a1502d626b5c846925548bf638dd17dbe52771cdba09b3b48d770b3ba29cba"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4eb6a90d234f35a6497a5c7d0734e763c16a622b8e37291e09f7d9e29cf767b9"
    sha256 cellar: :any, arm64_sequoia: "ec08367271e370814fadc27f76645b820d071890a9d57397b0010520c326e557"
    sha256 cellar: :any, arm64_sonoma:  "f7b73e7a84f3b072e2c4750647d4fb9f0116a57ff4a5901a420ad12a7fa1ad72"
    sha256 cellar: :any, sonoma:        "2a8f188b74dc2b57728ed0bd5b085e7ddbe53adfece44e008e66b34f5775be67"
    sha256 cellar: :any, arm64_linux:   "c1ee4f1e37ab270f85edb3e7d201b992ac5c415a2527470cfec96f6cd0826d56"
    sha256 cellar: :any, x86_64_linux:  "d87c9363286cacd72ae3f911ea9d3659dc0c881ca0adb1108e99b15106afea9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
