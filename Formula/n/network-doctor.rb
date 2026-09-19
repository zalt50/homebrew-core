class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "6df7e95267e095b5e2bcab7c96a6029b954bea064b1f9da3ee2e60c308efaf59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "949fa474e94cb487b56cedfb4b31a5c02ec00132c34761f2fcee719521e772ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "949fa474e94cb487b56cedfb4b31a5c02ec00132c34761f2fcee719521e772ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "949fa474e94cb487b56cedfb4b31a5c02ec00132c34761f2fcee719521e772ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a64c1623db095fa4863c0d82c1bc85959c509b99a6058e371324c83fdcb87939"
    sha256 cellar: :any,                 x86_64_linux:      "2786016fa617baceb0fca2be4f9987ffe6e91d1255ada0c9bb0a1983d8c2c851"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
