class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "d942c4695c1312c15109db8f14a0677c972d2ab78e28efdc2b8827dbe1306672"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069d916c86b2c551acfcfb1f63ff4b7fa29fa05a6226b5271615ba7937122800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069d916c86b2c551acfcfb1f63ff4b7fa29fa05a6226b5271615ba7937122800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069d916c86b2c551acfcfb1f63ff4b7fa29fa05a6226b5271615ba7937122800"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fe8b61a2d9bf094ed294705be8f651d35d9ff2c6c2f3d12bbb82ef2929e05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362f4b7975b61b945fa8562448a8efe7673828fb1523abe88c411caa4a0108d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9223b677d2ce3c8050ba6ecaabb4dd89e8004f43d5fa661df3d86b3bedc464a1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
