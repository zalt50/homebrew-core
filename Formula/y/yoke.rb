class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.1",
      revision: "e010ca87464a433f7c337ce5c8e4efde915a4bd0"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78c6cf84e057898df91fd725dada652f0ccaa4d1951780bcc1ca8ccfb269c9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab5683d14fcaef4c7d304f185f3c99cc2f680ce71f6ec3dc4d732757d90b888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8bc3fd04ef426305f06def123ce69463e99f397ca7c136a43f3711208d4834"
    sha256 cellar: :any_skip_relocation, sonoma:        "49971d6e24944a745ce6223d106c530ebbfbc6b11eb5ce951f4034672e19f848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81e22968504c7a7bb7f0f2493d660cae19a47ecf93e4fde5c398b71f92ec31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4ef1b12358c70069234b8a1cd4fa54de6d4e49d4f969b54680dc40a23edcee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
