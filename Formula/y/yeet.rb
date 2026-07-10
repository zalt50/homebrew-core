class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c76bd0513c4e7601c1181f99565d2015329622d7cb35dfbde06f40b020f66c90"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7731912163ebd80e3215d32cc825dc0cc45559e5c3658b8a060585a3ed5593a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7731912163ebd80e3215d32cc825dc0cc45559e5c3658b8a060585a3ed5593a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7731912163ebd80e3215d32cc825dc0cc45559e5c3658b8a060585a3ed5593a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b79046dbff0d67d4962a381411a8778fa0aecf1b16b176cf0ab39e92af5d09e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4d22dd46163d29754c5d9dc0598c96decdaa29f45022ec8d7091d0124f7a35"
    sha256 cellar: :any,                 x86_64_linux:  "c1197d02760ce036a2c87fee41a265328c3609f2399ac5e21e988e61659556b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
