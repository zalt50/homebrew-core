class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.1.0.tar.gz"
  sha256 "95fd39d3d0c5241dfe920b1814d33dec9870f993dd9f5ac37e736f8a3cbc0414"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f937fe0cdb8a997b512e6888f0d0424e73af725386cee11e5c54206f43aa37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f937fe0cdb8a997b512e6888f0d0424e73af725386cee11e5c54206f43aa37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f937fe0cdb8a997b512e6888f0d0424e73af725386cee11e5c54206f43aa37"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee3cba70c96ce5cdbc5dc0fb70816a50c5a6a09cb33e27045407d5fcfbfca1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23681a5b0dc23226a0983a99552900f58e3aa3fdd9e520c41e19085586e9e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7166ffb365457c70f24ea9032083a9d35df1f4de146157f3a3eeed24c4d37c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
