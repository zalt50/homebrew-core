class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "4692d2481042349c758eb0f7ee04904c4e1c26afc145e25b0833a42777c5ee72"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72fe7117debd1c8929dbf102892f27987642aba2057993465e6a13edac234cf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72fe7117debd1c8929dbf102892f27987642aba2057993465e6a13edac234cf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72fe7117debd1c8929dbf102892f27987642aba2057993465e6a13edac234cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc0443dfb9c056cc4c2f1d9df2caae106a51571567252571865fabae585208a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ecf07b4b8f75686fc1204643f26fd6dff3000c9ce89b19208990fd32ff8ff5"
    sha256 cellar: :any,                 x86_64_linux:  "c96153ec3ffb88dd97a63acc03846c3b61aa56c248dcc8b36f036f8fafcfcd90"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
