class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.4.0.tar.gz"
  sha256 "44e826a41d711c587d1f9c0f347f3c075c9a2597d677df05a6417d85e35273c5"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d03871efdaaa75c0938153af6b8c38fec52a34a6ecfbacf1bba15eb4172d2ec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a5bba9bcf204a760e4b577f3050498bebe95d6500fdae52082a5ff260b3a01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9627d367fe1c1172349030e4f700d1b944dcd78324cc9eb96690dc7889dff24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "108bae91daffd92dbd8b170105c13e1e45b59f9ae238bb2ac6880f3796f6fa39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001cf34f645135fde02a7c17fb58bfad8f05c79617c6b03752309c2dc6691de1"
    sha256 cellar: :any,                 x86_64_linux:  "b9e8fb94dff48b32a12c56d943df68833acb2080ba06ae85eaed6dc82b79c748"
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
