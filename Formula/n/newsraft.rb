class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.35.tar.gz"
  sha256 "6a87c8a9b8556650d18443baf827cf930aa4a5c5361a36397b95f275e28d540d"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0503f56ec8df91c2409370bbd1e4bb6a4fe1bb7b548f7c6a5027131c4e1fd069"
    sha256 cellar: :any,                 arm64_sequoia: "9c5b76e287744cb22b88c329d7d4efd68c003318e15ccaa4769d46b249c7f89d"
    sha256 cellar: :any,                 arm64_sonoma:  "e64d69519df37f57f796f6ae387ee3b5e8a0d79bc87d48bb42a3ff3e6a0965c3"
    sha256 cellar: :any,                 sonoma:        "fc236bce58fb28f56e1f764323bdbdde38da104f9c4aee981ce5733b785b5eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43f6a0257ee551eee06a888208a2294e5febc7ccd4b80110f91f9b8c2788b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f94f14616c1fe0f6d7ae4c5ba9dda5f13af30acd2e550646c82ade823731f1"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    # On macOS `_XOPEN_SOURCE` masks cfmakeraw() / SIGWINCH; override FEATURECFLAGS.
    featureflags = "-D_DEFAULT_SOURCE -D_BSD_SOURCE"
    featureflags << " -D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "FEATURECFLAGS=#{featureflags}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "[INFO] Okay... Here we go", File.read("test")
  end
end
