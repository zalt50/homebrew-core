class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.2.0.tar.gz"
  sha256 "b3f89afe71cc1db43c777d59efd3b96e4f565c96f70d753778bfaeb18342605d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20aa6f3293512e6d6fc1f9f825b32444d738fc941386fda101d1af3bba504777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88b4f44fa9a8ea0ce26fd081d07d42a640453791c2239ce07ad685afaa695d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ad2d738b293930d31272127edc186a89b2e84f022f270b1720fc08e1cc3928"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9d4e027ad4c1c949eb845c9561be82ee117e5285909c072cc11e92822d4388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c1e3bff5572032b01b0b5b531637ed6b276e433d08113ef3239182d29734b2"
    sha256 cellar: :any,                 x86_64_linux:  "fc63a770a353197cc02f23cd847a28987c42032d37be68844d3e11c9023af348"
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
