class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "cb1e040d632d50a25f42901279aca1c709d366c8d4334342190561e0d4bf9696"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253fa779c5af67e5256ccec1b23ffe9332b354ade03aaacb327e3e75ea6552bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e90047464a9607493b0ef3045d458b6469369d9e1b70a9a26ef2048cb615341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15da29c5b158cda79c4d5c0d89182234c1fc016377d88ce482a5b4e53143e044"
    sha256 cellar: :any_skip_relocation, sonoma:        "f610bcdfcb210ddda9f975a8ad87edcc18b09bf329450394664016f031b321ed"
    sha256 cellar: :any,                 arm64_linux:   "dda69a0c96ee33386be125ddb4332063af4e90b1b1cd20cf3cc8f2e89a7fd846"
    sha256 cellar: :any,                 x86_64_linux:  "947be5ab830edb9eaddb5b2dfd5ca4db66459466ab411401436c7ac4c2305df4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
