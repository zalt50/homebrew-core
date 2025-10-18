class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "dbb5a4708eb9dcd850b979e73b311dda308e99ae110a5733e00776ccc4a5f3a6"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1bea8c715fdb69379561d08e37c95878f11dee0fd9f45d3ff42afc76dd6332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b981dc9aa82cc2f4348ccbda3ea16fc443be253674b76884370804b0830b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28e30d63bea896830b058a7acfd9bd62446af7704a5246cb09eb5e235d66b2d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bba9a464867d7eb7a5386c9cfb96da87bd94d94e797ac3e8b05b44a924e96d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "838a95520af28dcc49b66f5d0d0634c85f6b7134677884e5662f56a4bd913480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25922871dcc575e16c26a86f5439cc94e24f589def9f943a36e175a0dc8ff3a1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end
