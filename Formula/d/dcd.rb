class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.2",
      revision: "a0441ba8c5c7d841e481413a56a1ebe4f8364811"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbb691c67719c1f58da3d76c505e8a90cd5d78669bb1303963875074d1b2facc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0da4b4e83076dd9e146aaeb64c680497144e900ead2899f181898cf9468bf39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e1d7b3248e4a89c141494da410a773c17ea51b2fdfbc675fb69f6b0ae81bf42"
    sha256 cellar: :any_skip_relocation, sonoma:        "f780454314f4172b87f43e4b18053b50434be7fa8cf6bc90218786011a9a9aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6275d317f4e2bd5497db511d594d2d6e95669c9cd2edb45239f7960aad8b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe10c5f269474c143e57fe407e68f3bbcda77e7c51adf71a1cea82501bafb3d"
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
