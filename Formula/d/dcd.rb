class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.0",
      revision: "bdcaa68e31749dd54ad2cb643c27798ad3e256ec"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6006048904b7f5e4ae9b27dce450550d44fc36deed5f12f4fd515fcd35b9adc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08616ad079c10f675b49bc3cb7d820e163da474949c7654b7cd50446981a6116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb7f264a3fc6ab05e1a22535436f4437161a6e89c8238f3d1dcbc74c087f262"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a1567a8b9f743d13db617fbdfb75888b656fe5dc7a63910143f45c954dc32a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22689ad2c5fec047715511e638ed5f4c015d2e5bc28d500deedbca0be8baca7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afcd67c61b56ac8da2ad9cea624cbe758d49729fce9dcfb8644377f00800cf3b"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec bin/"dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
