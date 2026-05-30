class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "6aa890688ba7a7671e46d0c65a5e3028915d0968bea6d1d64562909f7f10206e"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "772c5f77b3dba9e5882d63454764ebd41c52682ffa3bd3db2c75bc8ca728463d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772c5f77b3dba9e5882d63454764ebd41c52682ffa3bd3db2c75bc8ca728463d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772c5f77b3dba9e5882d63454764ebd41c52682ffa3bd3db2c75bc8ca728463d"
    sha256 cellar: :any_skip_relocation, sonoma:        "52cd1aff1274bd06fd7f9c8ed0c4040e745f69b98c07df54748455b692029806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8567567250a25ec7fb44f17308c823ec66ab4b30d3d6df7ba998146758553fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c5d53bf935c3e8199cb60fa19ee61500e3ca141a43aa2842ffcf9060ccb5c4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
