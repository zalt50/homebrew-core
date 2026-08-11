class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "7c111d821c4e73e221a90462988cd62958264779ec7d1ac42586b4be241a4be2"
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
