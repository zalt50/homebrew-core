class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.298.0.tar.gz"
  sha256 "4472d171c35b7f94f3fbcf0423b4132989bc4a1250a899b5504ea205bebea7c6"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ca3418951425898f4c0e75264d46c2d7add0066cc90cdd2937b941cce664c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f07efd514bf023de9cf9a22ea8cbdf8080a23f1d55fb2754f3923e11338cf6f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7baf3d39c98b9315ccb2f809408a7822ac97d5f37f236d321be2ca072bd63713"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ee533f29705d2762679f79d97893ef296228ceb46c1e60e4de8dffff5b40892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca97f02dd19567cdf32d39fb22c457294e652a9d96bec1893b2966f2a9d2b38"
    sha256 cellar: :any,                 x86_64_linux:  "806555b25ee5e74b33f56d985cc2b4e2b841fa1cfb5d964863bc90adb0030f31"
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
