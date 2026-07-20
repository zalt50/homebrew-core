class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "08048785e9769750813ead6857b193603cdf62eb584d459d119ef5f66686a2a8"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ecbe9308a22dd3b75cad71805121da530856abe8c7a856139709d5a97a08dc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecbe9308a22dd3b75cad71805121da530856abe8c7a856139709d5a97a08dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ecbe9308a22dd3b75cad71805121da530856abe8c7a856139709d5a97a08dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8fd6679272764bd05eeeed555b4c1300eac700b15fa3d8870dc147c31ec91d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0106b88af23771e52b86ce954119d424b63a1e297bd42e4ffb91c559d781a74"
    sha256 cellar: :any,                 x86_64_linux:  "daefcbc09b721108564c848800af80c93a53306c03089a966666ee48acb4aec3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
