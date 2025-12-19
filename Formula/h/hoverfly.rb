class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "f068ac87fb721a792d433771c4598f059fdfc41c3700e66ce217b5dee0253a6a"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c4f4e041404a550a762787af59af6775302cc98426b8257a8a8340b75bc6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77c4f4e041404a550a762787af59af6775302cc98426b8257a8a8340b75bc6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c4f4e041404a550a762787af59af6775302cc98426b8257a8a8340b75bc6f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b913be27705c393fcf1e0ac865af5fa54d08b37a6d3ceec73d987f2aedea5dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1220a0444d172bac2521b608320ac116c0a69a0f29a614a224d25d0dea5f954a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71324c768cf9dc9215d4a2cd88ba14b66bc5cc4aeed3be38396f7d8254a86553"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
