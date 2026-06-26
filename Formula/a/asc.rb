class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.4.0.tar.gz"
  sha256 "7beffd0858b7f1feda5d83553303118ff98c94ec09181aac4be14beca740bfe8"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7fa03bb85ab3eedb206d5c999d8f66d5b58592b96b8f896339880fcada16f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff188595cc0197492337517f34aa0c3e663c1f0dd369600a8f7da356c4bc0c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68809c8edaca71bfb1704dcf50bf954020b97a90e2cc452d7bcd3758abd058b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ad4f2fd51ccfc0adabbed2ac1aa097254862a369144e0b196be2dc4cb7e5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3890fff0c8389ad4cea731a8388a2c3119a25d00011deebe80300f64802998d9"
    sha256 cellar: :any,                 x86_64_linux:  "fd1be51a816168d034495e17a62f6839d73b257b9e067021adc109458346ca65"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
