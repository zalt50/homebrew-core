class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.41.0.tar.gz"
  sha256 "0f974938383b61d49c37a7ed54d48884af7e124ce05b589aae24002d27e19328"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98f03a379235a173ceb311f4242de413b29886b66d28f2362b89ec5de230c72a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98f03a379235a173ceb311f4242de413b29886b66d28f2362b89ec5de230c72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f03a379235a173ceb311f4242de413b29886b66d28f2362b89ec5de230c72a"
    sha256 cellar: :any_skip_relocation, sonoma:        "42846ffb5e6bead4edfe388cdbedc592e57cc5cd688354c2240ebb48c478e72b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05e4ae4b1813d551889d71543589bea3cc622259d3bc4eb494b4c299e1a4d531"
    sha256 cellar: :any,                 x86_64_linux:  "9049e2e20e665585afdce1b108bd32c0b039454fc9eecbfa0219bbca91db1ebd"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
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
