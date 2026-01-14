class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install"
  url "https://github.com/postmodern/ruby-install/releases/download/v0.10.2/ruby-install-0.10.2.tar.gz"
  sha256 "65836158b8026992b2e96ed344f3d888112b2b105d0166ecb08ba3b4a0d91bf6"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "830bb609eb27783b5bb8de44341d16bffd24f18fdc6f453d6f21ea136ef7b4e3"
  end

  depends_on "xz"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace [
      pkgshare/"ruby-install.sh",
      pkgshare/"ruby/functions.sh",
      pkgshare/"truffleruby/functions.sh",
      pkgshare/"truffleruby-graalvm/functions.sh",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"ruby-install"
  end
end
