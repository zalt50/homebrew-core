class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.2.2.tar.gz"
  sha256 "0e06b560332bfef4266696857c64cc948c0d8362cd524b58e099c0028ccfdcb1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f13fdc98c49da8d7243c6b9ec084d743f9c1d876840f208022098beca2ae46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a26650164bdacf20efe8f6881ff3023c7511cfd80e0c78f9df938e9eb691b4f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "924fc0f2cf0f241759925cfc7b629d4af35cc36787afc8e80d73e5c70301e0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ba7f2759cb098177011a9310b0d35618937f8905e750b0c50ae5cf56f5b7ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa5a8c385f2ad715edd07166ea3e44f9130e6add8c7e352ee08f5fb67332dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a118b690f4d34294cbb46f2a2f3ef72e2222cd07cf00b5bb5bab9c8d243de2bd"
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
