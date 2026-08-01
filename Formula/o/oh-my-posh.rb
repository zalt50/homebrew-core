class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.1.0.tar.gz"
  sha256 "302ce0d13fd88ab656bcdb9671038db34e3300dfa3b8d3d64914dde070ac5748"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9af867849a30054be7d8ffaf1213c5974c580abb1dbc89cdc04d2f5c5359dff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f49b2e2c09cd5bdd46eb81ba687eef169f676ee4f15ae8f5149890f3fb0b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b881e87605f7aea0c301f5ba2e7985bccbe1c4178b16851b72ecbe1f0bc2a2f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f239acff297f8d2a5b244a81951c23105daf8ef8a26ab502468c1820d7eee0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cdd75821aeadf02ff8efe2a24288452cc022735381ef647cdfc18b88635ad31"
    sha256 cellar: :any,                 x86_64_linux:  "2f67254049fcca1bfb994d4b2023866d8e47e9dd6452c1bcac0ef61c81aee0b6"
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
