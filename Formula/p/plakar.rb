class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f44380395c39889289b31a5f20432d85a86eba5283a804d4601ce8ec25a6c527"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "054379a5d933068e2b4cb8f48fc11769a05ec55f5cc798520266046948bbee35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f34a5a006de72588b106a09723fb32c3c321681652072687799cfae22ccce3cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd24298b97a6640cfe6c9b903e0a0764f79495cb7bc0b59e149a57b2690e44e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ded53b51adcfce38ee43603aaa60d7cc9222e26f18ca0ece5a69dbc5927346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a75c2526701fa560eb4af9eb9f49ee348a10591a2de1827b19c82efe6986532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e4bd7f403dc08a91f22db461e9e3647aeb5fde6c269d096bad97a5eca34f71"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
