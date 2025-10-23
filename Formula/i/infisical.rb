class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.16.tar.gz"
  sha256 "5093c60848cc6f7d5e8f68972b81f8cb366d5acf9ad7179831166423c3b03b72"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d6a41191ed940cb447f691d9ef6db4ab7f629ad4c219b9ccd3b2262239d912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d6a41191ed940cb447f691d9ef6db4ab7f629ad4c219b9ccd3b2262239d912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d6a41191ed940cb447f691d9ef6db4ab7f629ad4c219b9ccd3b2262239d912"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab750ca3254622670b52cd15e55430bc14509bec171fae8bd50bda70408e196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df2f3583d75bb3acf5634a11ce5d0c19bac8c802619b06cf4ba6602d5c1216fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c45e5f2af34b64d8b4d06f62ab15b8415eb68666abccddf15e4bba1889824a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
