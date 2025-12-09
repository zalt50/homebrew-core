class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.0.tar.gz"
  sha256 "45129f1b5f9857cc63a432d419c59923c734b6e7ffcf1fb75d15c0cb0c4722a3"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d117cf542d727b06904dfb3ee768def709e25e72e4c353e7457ef92040014eb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1336c01a80dc3a77283e1a955b959ebc6c58325f32cb166566dd18c5eac275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd45cb41a1a0eb2832386c430e9fe076058ac511e973bd18cffa6edf2ffef7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf07424970f3e0e795c2fdab3f02b1e7b5396ad287c2e7e5af19e6b1bf972bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d9156f1905e7d2b9a870576d0daf523339ef5f3184a112e59a1759b15a4b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3fc539618b5747166730b8d98fa10f1a38b0ed9b15ea2003070e8c046c42bd5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
