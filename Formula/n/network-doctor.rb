class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "73c93b26e92f6831d971654020f225f21e97ba2047194af28e609e71b293b17a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b70d3f2be52a6a9566b154a06b8139c87d486611d28a4fdbcafbe133629a0f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b70d3f2be52a6a9566b154a06b8139c87d486611d28a4fdbcafbe133629a0f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b70d3f2be52a6a9566b154a06b8139c87d486611d28a4fdbcafbe133629a0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b8d8642b8f4f0788f50100056e8550e2fa44521fe2560c31624207458d608e3"
    sha256 cellar: :any,                 x86_64_linux:      "be188356a2e59795405834ebbadaf769fe08627ffb0914e610270389cc6bcbb0"
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
