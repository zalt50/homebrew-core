class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.66.tar.gz"
  sha256 "9db590e5ffcf7e6e88a2c1092037978003b7e9474ad6653bab49a5ae51f5afc2"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b75bb543b8422482827eb3b019bebc72b19be695a9ee494e32fc64b7419be7d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75bb543b8422482827eb3b019bebc72b19be695a9ee494e32fc64b7419be7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75bb543b8422482827eb3b019bebc72b19be695a9ee494e32fc64b7419be7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0cefa077a332fe8af8ada28282c6f1ea09984d69a039892a0fc2487e16fa59d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "005324e6dbfd0a2413dbc39ec5e4d227eb7eb60c9dc5f430c62bfc4a813571cc"
    sha256 cellar: :any,                 x86_64_linux:  "81ad4ce94812284957bf88d93080cbb18b054fec9d400e8ec581929d99de7696"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
