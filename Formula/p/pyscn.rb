class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "af078951380bda0b459449b8ab098dca97c6c2b9f185b65632584b95ee03626b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "858ade31dce075b7dfcacd85e504f9f43ec80fb33a2d1a4c5bd2ee9b1ada7149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34da79115ec5c53d44c167e06ef7434645ed1b1198cab787d95710828c140612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52bdf97b1e5acb5ef8be275396bdc24395f7776510adfdc8a087d65d45efd342"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe371a11b015e4b6bb3521a074745059e44c91029ebd5b8a1e57a6db870b0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d053cd88bb655b31699b65adae94f5cf66a2a379db295489499684a77b66930e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1aa8850390ad2794f1c6063ad02f098c8761af4178391672ccd3e12436995cb"
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
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end
