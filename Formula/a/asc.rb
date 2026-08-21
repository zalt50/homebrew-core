class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.7.0.tar.gz"
  sha256 "61a205e287bd1cd81c3467798b77e751f1ca4e26260194cd54fdb739fb6dbfd4"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a44850db4977158f517ded673ac2315cc89a592fb7c4f0906fb3a87be25d55b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685caedac1d9626198867e23b40e4645c70c05d5da7b061051a6edc432d2d434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b96ff082ae1d238e5274711e2b72072d15041c696021212b00208165d375f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b844c30063a49d7c373b783d68c15b655f8692971164632edbab9485c7cf4e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f84ff86e33b4c5351a1ceefa91184cf4c4d66b593c27cd61b7d29c6555c46d61"
    sha256 cellar: :any,                 x86_64_linux:  "8b5c1f3467ee758fb148df46b96ae66612903f8fe959b28fb843a22f023c81fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
