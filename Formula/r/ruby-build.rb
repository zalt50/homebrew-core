class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20251117.tar.gz"
  sha256 "30884373951bb4dd9765f0969a2feafd47d3ea1757b9d542c33b84463abc2800"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0ede4034681e253b2256f582343f070eeb27b4f549d88ac4ea3f23a72aa7424"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
