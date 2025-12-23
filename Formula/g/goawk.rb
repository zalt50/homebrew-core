class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "2df274d8680a9405646b0729b6465b8952f795f118358cf8a25fe1526cbd0909"
  license "MIT"
  head "https://github.com/benhoyt/goawk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41ec09a488c6106ae4136236a4fbe46a25f8d0e8e4f10190f2da43540f3c0976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ec09a488c6106ae4136236a4fbe46a25f8d0e8e4f10190f2da43540f3c0976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ec09a488c6106ae4136236a4fbe46a25f8d0e8e4f10190f2da43540f3c0976"
    sha256 cellar: :any_skip_relocation, sonoma:        "e10480b119d8c5e75faf830c53f089ccef25fab153ac84eb89205b82ded5aecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "121e52f0ec2c1bb9fe0979b7b8f8134473655e7abd1ca781ed0b339b60187f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee1490d0fe3854a5700a2003f9ab151e262fd020624cb495d113660441f40cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
