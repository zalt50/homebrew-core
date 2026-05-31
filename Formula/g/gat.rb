class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "5548f2fe5ae74cbe526aa1ba34ae6b6694301d64e5d1d881bce1b8ed2bffeb0b"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6d13243269d4286ed8ecfe1ca637f5a48ab30c0a7b078f09b5f7f2e7da39abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d13243269d4286ed8ecfe1ca637f5a48ab30c0a7b078f09b5f7f2e7da39abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d13243269d4286ed8ecfe1ca637f5a48ab30c0a7b078f09b5f7f2e7da39abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9faf9d677e686b19cef0eab7741e73fe1823fa753785631d63f94729b0209c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8620abb62451fc287be7fc728003b4a297965611f1622b5953591104aee4222c"
    sha256 cellar: :any,                 x86_64_linux:  "77524e2ae8e5bd7c7847e862f6fdf3dfcd2efbe92267e7cf0e5446f07244e463"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
