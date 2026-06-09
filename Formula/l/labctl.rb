class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.83.tar.gz"
  sha256 "6ed9874b59c3c11c9d079a9aa7b1e56f214ab9c2c5f52136977e455faa77b1d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f345cc82514f41223d82a4b0882bcb42bb68933370e6c63eeb2271339fa488bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f345cc82514f41223d82a4b0882bcb42bb68933370e6c63eeb2271339fa488bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f345cc82514f41223d82a4b0882bcb42bb68933370e6c63eeb2271339fa488bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fafc99dc1643ab236d9c6b1da02e45ab253aae255161babc815208f7291c76b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f88def59ef702104895f31d94da0a1699446d2e66fef8d996112771b0b5cb3"
    sha256 cellar: :any,                 x86_64_linux:  "1d055bf82543f114030e4f897729e4b6b88ae5f503eaac2adb0531d2a21a0763"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
