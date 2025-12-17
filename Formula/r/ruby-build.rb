class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20251217.tar.gz"
  sha256 "4f33ba6e30caef149fc70023d74fe2d13a39876227aefb5c9f1718148b1f80bc"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b40580a21703afc9f8c14ef380d7559abcf31d0bee63da4efdad7f56c72f566"
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
