class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "b24798851d6d639b25001ba6bd2e6337c55c4162f0f96ebec91ad0ec95cc153b"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23ba614801d8caf10863e9ea1dd4c973c335b728076cda57d516796f8fb2d883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23ba614801d8caf10863e9ea1dd4c973c335b728076cda57d516796f8fb2d883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ba614801d8caf10863e9ea1dd4c973c335b728076cda57d516796f8fb2d883"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b99a7aadfa811862773260f0111eefe7fb69b9bd620f1a6a6b4b50c98167662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bbd89cc512432edf3e4964699790e6a5df9ae1b236498a18d1faad87c7bd8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc47ef57c98df925e6c07a53f7cb92f69fd21243c837e08c0797c861dd23fb5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
