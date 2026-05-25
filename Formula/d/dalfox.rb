class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "277b98f2d2f75380292d8888d0f3e88d87b0a35dcfb510f3be5a17cb4d3a4186"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34fca7de0f1956e6b1ea83df179e5b10e51b340576762c81932a996a10f36cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34fca7de0f1956e6b1ea83df179e5b10e51b340576762c81932a996a10f36cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34fca7de0f1956e6b1ea83df179e5b10e51b340576762c81932a996a10f36cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaf892c3ff3d3323edf801adce6a225d2b539f766e5c232105fd1cd771b815ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c347549daf66188211195aeec6be5cd4d3e36718989d71fd85c95f534cb2f57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20aa7083e59951a0d9dea3ad948856171b19c8d0c90023b88b361b6d3408da94"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
