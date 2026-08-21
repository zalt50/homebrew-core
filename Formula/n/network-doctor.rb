class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "277d9dc0907f38e1fbaf8213a3c89fc942d27909767aefeb00ce6640f70aa9c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afc7ebdec7587b668ca1a16cb0e18ca018f2536ebf9f8bcde6db15a68a3f09ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc7ebdec7587b668ca1a16cb0e18ca018f2536ebf9f8bcde6db15a68a3f09ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc7ebdec7587b668ca1a16cb0e18ca018f2536ebf9f8bcde6db15a68a3f09ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e878f212497d6a9cb50eadcf99a956380ddca5300e06220f42bc49d24e2579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8d7c79fcbedcde5a513a2e29cb9eab24ea28e5472f8c897dd5f22069d5673b"
    sha256 cellar: :any,                 x86_64_linux:  "007ea1d9f7f03806d70655773f600b8ca0463576050121f96770a84556900259"
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
