class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.104.tar.gz"
  sha256 "3f7f0cdc47ef781a7049b33fd6df145fdb10961c2b118d160fb1f12d41f3b983"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ad3def9b12273f19c7d1318ae709374a23cdee3b10f7f27d2051b99b84742da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ad3def9b12273f19c7d1318ae709374a23cdee3b10f7f27d2051b99b84742da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ad3def9b12273f19c7d1318ae709374a23cdee3b10f7f27d2051b99b84742da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d781dff27233fe1009872aaa73730d1b3325ac4ec308932c81bc912b2e0e7929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ed7aee350d7a316f5523ba12d67e09ecbf22667066d7ece8e2249724279408"
    sha256 cellar: :any,                 x86_64_linux:  "8a44ba9144e3ed28f78c99633e1ccfd2d7f369f8ca2312fbbd1a424ddc9a9d6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
