class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "bb83fb66c78eba14c6b76091f652151458f0ed367d34de3a88f80c273e42ad77"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "631037e02c05af4c059381430031b778718a9ed26bd61285da5cb8e232825754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631037e02c05af4c059381430031b778718a9ed26bd61285da5cb8e232825754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631037e02c05af4c059381430031b778718a9ed26bd61285da5cb8e232825754"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ee6548be40edff124dd587eca0f4ebc1cfa6364f5c9402ea9cc11a695fa552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ad9803b894902fd0f5807e7342191b5a0b46a23e70d1845d845fd46279f8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a91fcc4faccc05aa7ae5d0f601138d84317e49c1230ffb5a7cc7b7a0d40e107"
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
