class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.4.tar.gz"
  sha256 "91c0af58856e664da1f8be3bf66dc45f48e00d043b1df1b0ba485459b267d792"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "322504be28541d4918cc4712fa95202042cbb13101dc2934e60171537e852ce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea7902e8626755a86ee76c929d998d779cc2a6b6a47a14b6d1ed588043079074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef1c42a5b7237a0c55f33e62a4f1c4ec63852cb871999c8501f964c034419fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "39938dceda0e2c800bdcc005006e9d911b545e7f164bccd9da4604ec55705b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e57bc0bddc12471742ab5afd787e89a788a982a656af3b2341a70c3e179d6fd6"
    sha256 cellar: :any,                 x86_64_linux:  "381b246d3609721ee0cf1bb46208228b6ad656795925b306325bf3ab1d62a729"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
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
