class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "9e020c5371c373cdd2377962d98cfa3367547856d797f8926f197566f512171e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1433ef9d5a0f8e9c410c3dd1bcdd923046268f08a92ff1474cf10a5701f4c1b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1433ef9d5a0f8e9c410c3dd1bcdd923046268f08a92ff1474cf10a5701f4c1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1433ef9d5a0f8e9c410c3dd1bcdd923046268f08a92ff1474cf10a5701f4c1b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ca2a192687e18b58104b57d6d73303bee1eab7ef3f389d5367b2c7b7184cfd3"
    sha256 cellar: :any,                 x86_64_linux:      "369345ed317de519380ff44bf661ef776ff38940dc06486683320675972c24c3"
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
