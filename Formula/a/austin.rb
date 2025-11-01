class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "1a857d4590092cd8f7fc110cd83c31311dde03113a5dc4cb93c4eb31e5c8f884"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347455c789b6b599d6e4cc4ca51c3be775370657544b3059c305ac26afba0fc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3d0412250ee9d07be534682f9dc585ca5300a1baf6d6fbf5430f0458fa6bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e015dcfe89db3a0a8f0a25d3758caf576601f2afe606c68dd0e4e1cda0615b44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cafa89876000e876f272da9f9fbcffd00a163a698163e63d68a47974198f0c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9605282d9c525276e6fce34fd10b2aef37b4b8acffffdaf79d1862e3bac22ab"
    sha256 cellar: :any_skip_relocation, ventura:       "cf403c1e23f28ca7ac25153fefe8ea3459b50828a036bea52bd89783648177fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ad016d651f53868112221d8bc3945322c218e8e1138f00e94ce0115ee1cdf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f61750c13e6ad73505a47841f627c537eb23ce2259fcc7efb723e6aeb4396f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "python" => :test

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    command = "#{bin}/austin -o samples.mojo -i 1ms python3 -c 'from time import sleep; sleep(1)' 2>&1"
    if OS.mac?
      assert_match "Insufficient permissions. Austin requires the use of sudo", shell_output(command, 2)
    else
      assert_match "Sampling Statistics", shell_output(command)
    end
    assert_equal "austin #{version}", shell_output("#{bin}/austin --version").chomp
  end
end
