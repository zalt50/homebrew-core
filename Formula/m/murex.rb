class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.1.4143.tar.gz"
  sha256 "f3620e00dc431ce202216c935d8e509cf0fdf0dd1e363eee9ec6cb64b0b182f4"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "417c00058e5378121ae3404ca5b07712965c18ad089d788c0d3cead3e7b2467b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fb444e047917a8161518848784d9f5ae58462c6b2ddf8774d842c25b92670f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "589457c8c7503101910ae5b0ec181ed09d58e4e6d076d4dd66838d06ccdbee8e"
    sha256 cellar: :any_skip_relocation, ventura:       "589457c8c7503101910ae5b0ec181ed09d58e4e6d076d4dd66838d06ccdbee8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d26d93f9ed5986195da37c0399310cc08e89a484a94da38d4caa40f6851ee0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b0ae3c7eea4d5da28c711a84cce0fe4401a368f0cd64157bb62211e5acf002"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
