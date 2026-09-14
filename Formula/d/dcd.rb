class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.19.1",
      revision: "bd30b2ece9840f0cec963125e63453ba5f852cdf"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "a69d056277e120684180fc4b4acef0df10f8f315c315fcfc2a9990e5879d29ee"
    sha256               arm64_tahoe:       "cd3e29cfbefa673595e703a8e326bf7b55dfca9928be480d4d066bf0300ac169"
    sha256               arm64_sequoia:     "e7ac34b161e1a69c5f3e5bbe92d6506bd510260f58a9e84c060759c5b5ae1127"
    sha256 cellar: :any, arm64_linux:       "238ac1b78fa865b97626cb9103e4d380b9e7cbd9e5032b94fc7fc2c78616be37"
    sha256 cellar: :any, x86_64_linux:      "564c824bd3c0bceb21c3891931d2fcd3694ee88bd841e6986ae7200eaac68294"
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
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
