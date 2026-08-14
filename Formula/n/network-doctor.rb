class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "fdaaef6ec3df6d88f483c39ef96f80857e755fceb4363f2bb8819c31154679c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2f447a5be40d8c4448275c180f1a9e59552008b5668619159e29c400a704828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f447a5be40d8c4448275c180f1a9e59552008b5668619159e29c400a704828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f447a5be40d8c4448275c180f1a9e59552008b5668619159e29c400a704828"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee433ca1e7bf7f331f984f8e3a5d5557ba64d8a38ca36999a99bfceda3bf7a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacd24dfce06cea3f0acfb66864bcd17551f13288ceef71cabeccdd975cad497"
    sha256 cellar: :any,                 x86_64_linux:  "8a2b88453c061761ba0e4fbb47ea9b9d0ae416a66390df2095e104b47de04d2f"
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
