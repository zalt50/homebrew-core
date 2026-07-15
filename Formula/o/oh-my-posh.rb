class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.30.0.tar.gz"
  sha256 "e33df397333f98544d782686beb5431451ac1a1982786bb934f79562185379fe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33de16ee090185b984b580c72ec7cba4cf994a70fd40709893b2ceca265ff14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5b6457a2dedf68d9eb3aeb047c1ad8e741860a21036875f7bca3789798a41c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70f16ae5d6c8877f8a27c507bf47de925249b534fdfd12b5ae520736848bbc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d962c64a87dff41b77075b973bebc424738290ed7de5296da6d03237531336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "785acd0182d7889cca803bb3d5c665c60d189ed1a7b4af0f0f32ec02336b9ef7"
    sha256 cellar: :any,                 x86_64_linux:  "f8abc3216fda4a3a862ba414f44bc16b404257fa565043d6e44352a958c84e3b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
