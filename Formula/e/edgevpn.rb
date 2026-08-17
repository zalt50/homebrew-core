class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "9e792a7e171306eacca7b0d30c0ceb212885fcaf10969020eb0ba5c443e5f99d"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c440164485cf3214746869d080c16929ee773d7e7af143bdf1f3b10901ceca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07eccc626e0f8aadc64282371500856fc6b7f52ea14a830b6cd9f05fd05026a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559c667051a94e44e174180f2d24c5feb5cebe5ea86fcdd61caef95585233b25"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "api/react-ui" do
      system "npm", "ci"
      system "npm", "run", "build"
    end

    ldflags = %W[-X github.com/mudler/edgevpn/internal.Version=#{version}]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
