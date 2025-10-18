class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "1f4fcb4c37e9988c744119990b6abe00dfdd85f45b1977d7d65eb4b78573100c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85a30b02ea2324f7a0926268ded16b7a7c83422cc48f9b1cfeac1fc1e93a56c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9082c3d04f630353c7e24f177059ff054ac3863b2fb8243c00c923dba4acaee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b35fa12fb7ee1fa69cc18c96dd4595d202180d15c7c8cc0724bd757851ef5bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e7c9b9c650e237f1175a092e93a57974444836f8352a20305a8b6665b873f5"
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
