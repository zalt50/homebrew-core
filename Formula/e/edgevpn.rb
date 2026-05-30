class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "6aa890688ba7a7671e46d0c65a5e3028915d0968bea6d1d64562909f7f10206e"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee7a5032627e671a95f17d34e718bd7328b435c53c55ea3627845a7c7cf7359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee7a5032627e671a95f17d34e718bd7328b435c53c55ea3627845a7c7cf7359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee7a5032627e671a95f17d34e718bd7328b435c53c55ea3627845a7c7cf7359"
    sha256 cellar: :any_skip_relocation, sonoma:        "6207566f956f421dfa35613cd59825956751eca7543fa067426a0c57e75c1493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cfab13ef07c85ba7a9991806af395dcb194c20266aac413f49e4055e97aa350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2e18853756e6d6b048c48b29756080dd27c272a4255dc7fc7f137483b0f2da"
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
