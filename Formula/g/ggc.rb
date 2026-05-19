class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.1.tar.gz"
  sha256 "7649ca013907b76b286352e6d6cc35dd0d21ffa848b4a8ccf74bb66a3e5d0dc7"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f3ff6f615a3a33a0fda30a70b4f773accf0b2c653c74d6025a1ed1539ee458b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f3ff6f615a3a33a0fda30a70b4f773accf0b2c653c74d6025a1ed1539ee458b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3ff6f615a3a33a0fda30a70b4f773accf0b2c653c74d6025a1ed1539ee458b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f355a0ce08f023e05eb438d118fca320d125e2021d94201b6006395e5f9df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de0068d504e8510aa08516e6f248cf53e948a0149663d27d4195c4139f61a58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be97c4aae64a166585f54e113d58b60091e56fe94d472ec1cd620e87197abe3"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
