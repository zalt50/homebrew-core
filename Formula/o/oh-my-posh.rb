class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.0.tar.gz"
  sha256 "a0adedbbbd3c6fb839226c04bcc34d037508eee3d2832faa636e614c114b2da7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3902c06472172118045ba7d8f0a6c1f43b8c9882f7f289c10aa28f56b74e023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3b5c4146e57330760d0bdf865e8e8d75b0f3e361fa091d6877a958b5b172eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa880c2862eb07d96c82efb27057dd76f5e7cd4c7699d73187ceeb65eaeeb602"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0fb2166c9d345dffddc63fbea4e1788b2da81c95c37f26c166272cb5535c57a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c2e5951b5a41225be52945585bd715878621a1a47abe003430c874d9922104"
    sha256 cellar: :any,                 x86_64_linux:  "d47ee24d47f2a6cfb8aa15e9a7304855b17821762202c6e4764acbff0972e9bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
