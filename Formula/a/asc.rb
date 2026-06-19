class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.1.2.tar.gz"
  sha256 "d48da49ed49e22873eaf010a9b24e8708cd6c271d3da21bb87c679be8b638cb4"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485798297e073dcd7ffb32273c5b6fda14fc389887d2df7123aac0957ac39245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a585aad6cee1bacb5b7a2249d87d387de65278e366c309a600e0f3857aac3945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c31700bb3aee1627db89aeaf3f99b1244ed4318d57a9c2d2d5f6aac43bf97b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "104ff41beb4722c007f4b3714517e04e3c32a4cadb208be4e5a6098301bdedb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917426747ec88364ca6d37fbcadd698d4d31efa4e6d696c64591810a7b231506"
    sha256 cellar: :any,                 x86_64_linux:  "84578eff08264c120119d21d9bb96728ab8358267200a3d92c2b494fb924563d"
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
