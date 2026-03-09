class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.38.0.tar.gz"
  sha256 "63036d9e944594024b165be808f46d65b52a5c1cf618a31efaf50e2c5349fef0"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a35cc5928f4e70d8842afae54da284521fe693493da2863eef221b4bd4ccb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8f0228dfe536764693410cdba28ac8b1cba9646e0468bce5d033b65b0730e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "addeca4bc28908f768854b4e69d57a476053626917d28b119b5cdf0a7f8b7ef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "255712f25085846e8e9910270d3c4442923aa5fccdbc272b250fee0f4decf992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cdd555fbee5bef344afb6c82d77b967f77eb151e434b5af6873838fd1a16f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d2d7a247d904d595996ad0b72e2ff8ac3c2d8a2b0e23891c2699636f6b9966"
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
