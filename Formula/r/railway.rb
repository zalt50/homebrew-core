class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.61.0.tar.gz"
  sha256 "7e1521282e4ecd8d25269827c171088bf5f17ceabbe2916ed125ac262a306749"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "822a382aa3c91a102cd4c85ee9b5b9e36dcde15fb1637b91600f6f42f70817e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31256edfd21b83d3d98d1d119800a979c358b3da203f36e908f9d335ecca522a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8296b9f18afa8346af801009829dc453d5fc38f6fe2710aaa5cda4140893ae59"
    sha256 cellar: :any,                 arm64_linux:       "6e071be4711ca1313c8c7486d241e2b056940ee2f066839729011a01674fa8b1"
    sha256 cellar: :any,                 x86_64_linux:      "3375ba285f6efaecb088a3d3c096d3251369463033d5665cbaea4a9021c46dbf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
