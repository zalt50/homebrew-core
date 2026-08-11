class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "f0f1d32f7472021f5b06aff242a729b2d9463d19ee1c8859b1fd721374eb7b92"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d58a39d56606460915502ff37934834ff46f6478c6587641c05e7bc4bb797b48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d58a39d56606460915502ff37934834ff46f6478c6587641c05e7bc4bb797b48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58a39d56606460915502ff37934834ff46f6478c6587641c05e7bc4bb797b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b8c94429f2b02e1c3a05bf110f00f09aa50786ccfdc429a183f82839668673a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123d35889a45188ace473f4499dab0f3b4a74c5e5a675be52726e1ee55be79c4"
    sha256 cellar: :any,                 x86_64_linux:  "fa6bc5115e82fcaf911c5fef290714c79820bec18d8408bc4bd8c7dc0c169c4f"
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
