class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.07.28.1.tar.gz"
  sha256 "407d3f5893d323bfa47898ef5edfa5c90f3b38bb49154f61fead9c5889f62b65"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "63dfd8781180e8bae55a148034e44acba83627999c193510d4ff585b85c4a01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f855863c042117b3c019d31076dc8d662754303342b7cbc01e95724b0ea4ddb3"
    sha256 cellar: :any,                 x86_64_linux:  "eddd3cd4c5b6c333cdc3fa4af3a97ba60b02171c82175f4da794eaf761fb1bd3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end
