class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.5.tar.gz"
  sha256 "30a147b27a95180cf5dafb11247ba3d6ac9a26ea355517872fabe7cd816107f1"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92c36eff80b7e373e36cbedbc923a456113f37dda98d8853d744f2e6b6aa56c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c36eff80b7e373e36cbedbc923a456113f37dda98d8853d744f2e6b6aa56c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92c36eff80b7e373e36cbedbc923a456113f37dda98d8853d744f2e6b6aa56c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7115849ef8e94b685c9b61536004b4d119e3a4c8ad7ece7f9c8b020fc46884e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4abd8a8f41764e61117a748b012df0a78821c7db91f81d25049283898779ea04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f2895e00beb5737cada4e9b9c7047d5b6af04ca4039a6413081e98936ffef8"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
