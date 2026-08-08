class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "4488e38a6cc5874c689f6f06d0de74b4a91a192b025fd96e3bfcb82db27fee6b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c123f89de13d4d538aba9b679fba3131aa56061ca6e0ae5c49b53f7f99114897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c123f89de13d4d538aba9b679fba3131aa56061ca6e0ae5c49b53f7f99114897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c123f89de13d4d538aba9b679fba3131aa56061ca6e0ae5c49b53f7f99114897"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cb85d556b88e0e7c9406fa03c9fa0f27f08f922ada494dc5181f6bcda84ebc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3153b29185aea7c5b461fdb4bfb0cf94779aad51747173c165b7ead3a9d2065a"
    sha256 cellar: :any,                 x86_64_linux:  "2a736304e5ac1f3c44a026ae928c6d8b68c897ac9684d47b3019da03c3b41d2c"
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
