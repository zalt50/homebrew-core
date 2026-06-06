class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "dcedc83369ea904b7148bd66b573ccc1cd27fe38ebd29bfde5299fd635704be2"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f813f9dcea5c867d94d1204f066b0057bd710f09645910878fede893a66ed9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4039f361066fe3e95f843b0792c8952618180887c632cc43923ae08045a2612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6474498cc2461c45ca9d13ec2d06eddd829a058e302ba577055fdbad6621b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "240ad7720a364da677be5e5429f6d0c2651f796b54fe049a77a9ef5eb572c4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "516de1e01ce54be427315e9213b18eb862dc371eac58b75143e362c8225131c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67ed27ba9be1b398eea7d8d7c1f7e8ec89483d07dafda05d0b1026498d9f31d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

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

    log_prefix = if OS.mac?
      testpath/"Library/Caches/bookokrat"
    else
      testpath/".local/state/bookokrat"
    end

    assert_path_exists testpath/".config/bookokrat/config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
