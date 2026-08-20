class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.6.1.tar.gz"
  sha256 "d142511027867b5746918d216161f1857fc045f4d8b82da52745a51770ae7f2c"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d13c783c9a5a9f172b119eefc1985efa0b0ff562674c8a070f968674d4ca7f18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642cc5ef960a080d432c4462d659b7e2316f7e96a5a7275ad474a4b4a7daee80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f299af0ead1b7fbb41644ecf6d147f74fe1555be388173ea94bf2197f9464feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "839f1b8c5d32c7a7c487d904523d260da0c2f29d9d1d3ec6be6d54fa80f5914e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6abcebdeace5b0b0bb344f85cb9d29bb061392b801b1a009b1c0509eb0b0f4"
    sha256 cellar: :any,                 x86_64_linux:  "6538bd7057229290cd98cda11a0b6da1ff9a246239371d2c3fd8bfabb0a3dd68"
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
