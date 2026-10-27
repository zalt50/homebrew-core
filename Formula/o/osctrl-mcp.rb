class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "81e8ae96525845d56ac98c4a1c3764f6bb59993f50d0d6011ba1d5979173c26c"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5baf94fd54ac9c250115f920f35b59e289bf7f615f33309b37cb2c91e8962865"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d1d7cb58b897b04160e75c8b8f0e91399f6576219d95bb003c9f0dce814d1ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "852ec2d7f01cfd5037ca4ab8630800b23e241749290d4ae5439d2267c712b0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e92f4e3ee74fa76f722376f9cc78e8f5e95ee084d86f947580a0c2835b66db46"
    sha256 cellar: :any,                 x86_64_linux:      "37a037f0d451d3a3b48c6b87c41accea75577c4831bcb3a8f53079b24d44e37a"
  end

  depends_on "go" => :build

  deny_network_access! :build

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-mcp --version")

    output = shell_output("#{bin}/osctrl-mcp --api-url aaa 2>&1", 1)
    assert_match "no API token", output
  end
end
