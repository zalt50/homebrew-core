class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "47caa59c65c03bbb33959998fadc677039c32e268f66664f18a98e8e31f71603"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0500bfbe6e22fd5711d2f1d704b26b50a23a44d09df64fa8844afab6b728cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d13a773831af1281f089a4bb76188b4ce028adfdabd011a7ddec00ef57defd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85cee375129158bb584106fe50582ce50d43584b8a84aac36717df481170fbfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "10eab81215c9d2ef2dc203b3f705e036f94271b3d078ddea19e44d07341c9327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92db539f5bfccae7d75663c86b1eb61aa44e9e1f4aa59cd90d2373953b8b9088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fae64ecd7e3f18fe9f92cd1e0d6a6f76c814549f959b389c5007a077236e90a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/version.Version=#{version}
      -X github.com/openconfig/gnmic/pkg/version.Commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/version.Date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/version.GitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
