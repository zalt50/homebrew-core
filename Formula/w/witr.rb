class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3363d7fc8979a16af3a3306f3a8b11b15b7657567262e4f971102af2152943bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfda096376dba262cffc42dee4095b0a8047fc294108f3a40026d95e3e02fc38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfda096376dba262cffc42dee4095b0a8047fc294108f3a40026d95e3e02fc38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfda096376dba262cffc42dee4095b0a8047fc294108f3a40026d95e3e02fc38"
    sha256 cellar: :any_skip_relocation, sonoma:        "9701b698724f10104c24ee35a56ad02b57ab18b0e794ea88da08505540bc33e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b2cb619641a8503e020d354f4acb9a5c6dde1c670d75fbd65e3cdd9eb911e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf1d14cff45729320ed0601c1ea235457b54673f85018709a2ed6f668f82a1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end
