class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.288.0.tar.gz"
  sha256 "9a77e70313b55c8f545f337032a20e7e4b20fdd09314bb55643dca2b30c8fe44"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "650de6530ea66e1b99984e806a7fc7cdde4f4b16b6c180e4c7ee6e73cdb523e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7918eb19a548e793347951d092aceed70b46d8ebad56412026551944d4c8350b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "713b859b6e20a95bae9c00838ac5a9be854124cc3fd8dbd9f9cf3a6220ecabc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "49cd9cb8e26bceb25da71ab8138fc35f0841ff26f57e4cc8b4d05d3822e8d652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3000a18b52b77f3a59cbb4dcb21df32b5af217ec0c27d774e4cc0c438ab3fec0"
    sha256 cellar: :any,                 x86_64_linux:  "633d768464e67c563ebaf3746d4b7ffd185d9c047b1e2fe1b0641e3bf122209d"
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
