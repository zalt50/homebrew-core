class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.9.1.tar.gz"
  sha256 "4440f3e65faef9b9cb66dc61eaf7c3364586fe6767f41b9f66e5021920c71a31"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d75a8ddbd7cc213fd97095617f2482bb7bd6b93f13b06934289c8647c0ac333"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ab55e80b55c8618877cfc609193f8c7d420c6fe4813f8a48a33237e7f0faf14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b43e01a206f785c54d1035f26ca8c257cbad1c6c06201cda423c2e7b5a9b7d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8f5558fe7b59cbafea5b35a27efcb5357058848819c11f7e41bf50124ee30e5"
    sha256 cellar: :any,                 x86_64_linux:      "c5d8fbdd2d7a30c0e8a13446b7d3de30aff94d560ac9fe71802726c9381f46a8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
