class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.6.tar.gz"
  sha256 "c8dc09d875624288b350c14d83df6d2b750ad8fea42deab1717190c766d8f9ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ec8743a911bb40b1584b74825c972503ea2acea2030b73e55c2af93da6be92d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ec8743a911bb40b1584b74825c972503ea2acea2030b73e55c2af93da6be92d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ec8743a911bb40b1584b74825c972503ea2acea2030b73e55c2af93da6be92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0428eed3e154992eba7f6f85459a237bcd3e6e06aad3a18410571d4b890d96d1"
    sha256 cellar: :any,                 x86_64_linux:      "de048cc9b42b7042f3890c3012e86a67edcd1dee93823151d31f49d4cd5e36b5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
