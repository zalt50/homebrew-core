class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://defunkt.io/gist/"
  url "https://github.com/defunkt/gist/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "53c72eb07bcdd71b1a8fdd3f81a3cc44a332b92c34a30632e45d6941c10f3096"
  license "MIT"
  head "https://github.com/defunkt/gist.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8efc350b478d929ecf6de1f41afa0763fccf1efdeed3c16384deb5b4fb8bf66a"
  end

  uses_from_macos "ruby"

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output(bin/"gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end
