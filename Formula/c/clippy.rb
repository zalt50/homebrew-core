class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "55eadfe29291c7d37869428f7f77a81f193f7159a853bfa63d41375c01de06fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30dd4a9625465cf5e638497eaf2967d62dba2912e2ed55c07346d3d847d6e921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842b46e58f47739806db506eb0c95405c6704acfd8424ffa21a111c7a0e28b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a6017511c074220c63992dadfce91fb760f8046f0a19296a78683c5ea1d41f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "973d89b6b1bc852e724250068b62c53f2985b661649fc3d56828ceed09980d2d"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end
