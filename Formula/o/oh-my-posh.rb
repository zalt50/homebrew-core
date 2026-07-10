class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.25.0.tar.gz"
  sha256 "142a0391b7db020806e0c19c5e66ebf9ef48910da6d8711fff3faa835f7f549b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a78ce4443ce8367f0d1dacee787cf7d4d13b3b4015bec50e431a015513012c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31b29a0d63089ef4898ad9e74e1b48ee6f7cd74aac481c4c3f8ec803ffb11ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566783fa6f7e51c3287bcfc43119ba2328ed1555841658abec1f7bcd248a3c55"
    sha256 cellar: :any_skip_relocation, sonoma:        "28824688cbf7fc0a32ebd1370435309a75df6997ba6ecc6f4538646cb5dc157f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3bd86565b45388b3e527fa07ce8fa5f1b56d0b0d665b80a8216fce90db71d21"
    sha256 cellar: :any,                 x86_64_linux:  "1c8d69bd6eb26e21087cc0dfa64cea77bcb3325d6a93c8ff3f8da4245a7ba636"
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
