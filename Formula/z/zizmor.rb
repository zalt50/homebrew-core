class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "4a682f4bc8b53c681f51effeb3767f2b766a018a22efd72655fc8cee857afcfe"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeb74339780da6fd67b9d03c135ceac443fc39c83630116a2a99be9e1e917b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7901407e7e6684516c534c7d174dd23ab360eab3b2033d74dd4962f67323f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0c5b27f213a30351897b098d61065615358e55c68ef1270ee8f2d9843204a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8bb5111b6b8717f6c40fa81f8ec7cdc115787786698214ad45b4256a8245f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80de63ac13d4fe334fa12769655e6e1f78413af621cd0b6e306695c2c239c40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a3ca6b9fa829baaf07cee740739eadb339d3b1577ce651e68175b92210ccfd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 14)
    assert_match "does not set persist-credentials: false", output
  end
end
