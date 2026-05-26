class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.5.3.tar.gz"
  sha256 "e1aeaa7636c0ad21360cbc54cb8540b7495377ce7d12bfecfa0b121193b9470c"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6ad1190e469552b3d248c8fa8417befe3597b55371678edb5eea44b8ee5a2f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166e85be3654e8d13b6747f4517156882c162c113fa6697cba3438898ec6369f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aeafadd225cb7aff2fc17babe430c77481f36a7e892a827835c5622229ca440"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf18bee8758b5ed79bdff1398fd63511f237cf16543eadb692b54b9b2912d2ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52974c208efd0ac5ae3804297f8c509359a14c601c5d4cb634195ed8e2357753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7b892f842d5d08e7bfef89c3c464d0136f4fdcd2681eb19f687101b6c5cabe"
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
