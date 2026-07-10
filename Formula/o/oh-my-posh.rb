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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38d560557b9dbb46096a2551a512e1542ff7412cca65e2790744931c7383549e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2fa700afe548fcc16969503fa6d15cdfa0bf49553cac1cecef36776649951ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80afcaef114d28a4fca066d26305c5fe4f491a47501c3652ac9b50389fdd27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d82b20cfacf18d1a14bef8596ae2408d6d28086100cf2949114825030ce43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c0795334218ede3b12243f3d75f44f96eae344429e80f925633d827cbb024e"
    sha256 cellar: :any,                 x86_64_linux:  "e6e5369541839323c153b5b3d0a0c5d881849ba1179884a9ce6f318a1e82db32"
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
