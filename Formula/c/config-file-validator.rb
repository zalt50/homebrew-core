class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "43d2a3000424cb1e4eeb38c7ddd444930140f2ae106ac1ac66ef7b2f9451d631"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4bc5be0c97cddaf53a02d368784a2ccea34df5d964770399bb5347c6157caba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4bc5be0c97cddaf53a02d368784a2ccea34df5d964770399bb5347c6157caba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4bc5be0c97cddaf53a02d368784a2ccea34df5d964770399bb5347c6157caba"
    sha256 cellar: :any_skip_relocation, sonoma:        "47902773c3a0db15ca9f5516697294f6ac66ac4f3be15af17047e9e410c07fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b08797cc41e65ac7b7a02d24db1cb044012514b0de2b5247147a33d6a2a134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819c8397da06c55f0f53bffc3fb73d459195950412813becba8d04113ae9207d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator/v2.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
