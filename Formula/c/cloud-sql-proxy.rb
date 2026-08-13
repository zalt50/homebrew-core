class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.25.2.tar.gz"
  sha256 "02e705c384b31343dc664394f4614679a555591f1415c4dc23513bc55fafb5c0"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644ed7de5991ce9ee2b62accb0788cc9cbfc89646e2650a67ed5686fb7a67f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32bca2e07925ce8ba169867b30ac86c78fa43f83e7162e535eabc9c6ef94eacd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208202fbdb0c781fbc86a4e82eed5963afaec1742b97e16072181433b60bceac"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d1700df819aede6d039a03b102be6f19a9d40012e20d6a0ca96a08f307518c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89365687d96e36853840c9643e0315a01d9a3845eb4fd9a223162ec3bc018ecb"
    sha256 cellar: :any,                 x86_64_linux:  "789db0c601b58775c866cb90cc6ca5df028ffec8e6a68ffa085d4f3f1cb599a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
