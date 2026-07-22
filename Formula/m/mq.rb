class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b74029b09be3e00710fc637fc52812ea604817755e4a658dc613f2b4e25f91a0"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f67063f6fd0c973f19a37d0460b53c8d39c0d1ecb49b3ad24b26c4627bd0fbd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5a2557fcad4ffc56a148c491ebe35012259b031bf31c1e54648a48925dadbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b6f84d3e3cffc1a3bb1a25e286211dae2d247d51c4ab449c6e7a6a477c3980"
    sha256 cellar: :any_skip_relocation, sonoma:        "353f87024b534b44c4d11d89a6c51a483699ec357b6389463691028de7121603"
    sha256 cellar: :any,                 arm64_linux:   "cedf9c4135925e85cf5091bc3a3a174d04fa1c7da0e32064d6279aa3148bb7a2"
    sha256 cellar: :any,                 x86_64_linux:  "41c470b86dcba0fd17faccad4caffbf44869af67ff08563a1e2348190bad317c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
