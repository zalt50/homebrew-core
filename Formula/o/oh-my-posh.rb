class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.6.1.tar.gz"
  sha256 "1bb0d565aed8e13eca60f021884d01904ca545503906ba1b80623e2c09488b75"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d462604713e00113cdad407c33b2164a6555274d248caa330efafc716e76469d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8125140518b2be0803b08e682fe093b5518aedb8cd6d9571941fa4136a6217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2f2523c9034d6132ae92bfb2c60c91dfad224fe0f65651b63a78dfbb5de55e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4914b03e0daad21c3a40f0d1b2940a5dc1b076642c7411d1b5c4ecec92f884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3905cfffa5c593132894afc55fd2c56a5046ca6803b64929b954500ae227ad6d"
    sha256 cellar: :any,                 x86_64_linux:  "4513ebdabd6fcf10166a9a319dd95eb4b0704c79026cafb288cec7c0c23d82c8"
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
