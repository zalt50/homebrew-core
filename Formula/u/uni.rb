class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "e9208bc0028d239f9cfbb701d98b14e93eddd138ac6433c6f2f5718244ffa5bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9106b7d68010a9ffd56317f7825f5da7ca027af685a3c6841c1c4787d8a90d6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, sonoma:            "a131397f7f865c776486024e4668308ff4a63922d7eee805c1c2c307585c235f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1001846eec11d144b88ee69a1c3ee92cbd310b927cfd3155fb238e2045141864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b618682972c1079e2d48c2edfff5af4127d50ea45a7768fd5c483d29bddb1c94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
