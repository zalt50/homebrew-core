class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.8.tar.gz"
  sha256 "b364efe0322e3d7b522771dcdfb4b0ebbac8382a7488ee997ef0c12c300e5465"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a75e35a6a9127a6ab33463137784b18ffb6d9e4c11b4bbc480d51f9b8c1699f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be013040e8df4f94e8772e814bf9ef6d72b1101640eeda627a3211b9d110553a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6acdf84a4671649a61c28270d67dfe00e39e1d4da747ff91f14a8c0869e09dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87ca7cd5d2dac57499a07d11f81be4ea6d0ffecf28f11efc4ee41694140980fb"
    sha256 cellar: :any,                 x86_64_linux:      "767f9d864e554198a05652329e27f7d6c41dadcdc71a9da965edb5bb5fdc2747"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
