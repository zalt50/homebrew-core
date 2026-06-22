class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.0.tar.gz"
  sha256 "034e9645b980071dba922839e0878680ff1130fa3439115cfd525554e01a2340"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52e9dcdc9873bc17b3cf654cb016d9b5f959150bf0341234fbe1d7a0c6575dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e9dcdc9873bc17b3cf654cb016d9b5f959150bf0341234fbe1d7a0c6575dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52e9dcdc9873bc17b3cf654cb016d9b5f959150bf0341234fbe1d7a0c6575dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d031d76ed0267c3117097ae53976e7fa10c227c34d65a88804611c0b8906f57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0189e36a82c1e60c60fa05f000342a6efe16cda107d671611f9a8f887972866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad33ca4f81c53c38e2a448b31a4a4f29e7dd1d0a424f331ba20dcb5a0235e3ab"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
