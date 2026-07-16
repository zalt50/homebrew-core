class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.303.0.tar.gz"
  sha256 "0ac4b677562f01a784868a011afba62098db7e12cb702f276370dbf6d9a20d23"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f5d0bda962a7c72578948bc5f42d01660cd4847c6d372f6e0b37478e15cd48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5ee8de93e86efdf7aa1ef1ce05fffb2e633b47f585a0b69e5430c65fd65560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae824f79742777d4d16086ae8ded8fd81b17a9bef36e078968a0cc1aec38c93"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a46e7cc33bdce5991ac08cbffc7f95df09d2f786720f6986b648c3c0a9314b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c6c8744c9be398004b8236b209b0a951cc94f4708b3cdcb096b912d1de29036"
    sha256 cellar: :any,                 x86_64_linux:  "55c8a13e3deef6e98be499a6ddc56a12e3c3cb9ee6515dad245261359b9ec534"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
