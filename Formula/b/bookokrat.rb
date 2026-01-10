class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "24f68f902744138efb72f50388d96b95677b9455ce080263a5b5795ec1cd60d2"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa7a415c17f090fea2057aa9e6e94ef63b30e4510cc53f791feb3711759a48f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64576761cfa3434a8af7c6a6f63d604fa8530038acc7266d9254e5f6f89a1d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1427a0ef4c3a06d1a2a5f98c048db1d143dafc74b2f2b92975aeea0ed754c2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "7893e940b471334b24065aed9325c2f556fe4f67fad1a323ad57ea8e16c9b02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5228a478d71f7b0666855dd85804fa27aba76a07344912c718a869ba7243dfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f39489b128a4e299023cc0b81d29f8d15363d7785eb1cfe1d52e539e59f1defd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/bookokrat"
    else
      testpath/".config/bookokrat"
    end
    assert_path_exists config_prefix/"config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
