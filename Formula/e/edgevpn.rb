class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "99dc073f38b019fb4e6f5645825db516277081e8541aa059ff902417dc363061"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0571b25901a26a80108445e14793337066604685293d9cba0fb52f28eaf7e7f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0571b25901a26a80108445e14793337066604685293d9cba0fb52f28eaf7e7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0571b25901a26a80108445e14793337066604685293d9cba0fb52f28eaf7e7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6b7abe9e448f5eb8961d592f86839ef8aa6ff09d49900d1b155b4dd7c3ba68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdbfdf6cdc5cf1668812d1e2e89003fd39beeb1723d65482ee4323471d197a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55b9ee83dfb1f73b2920ef44642d43f163a8d365bec977260a4c0cb65bdaf83"
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
