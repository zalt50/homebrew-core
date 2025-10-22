class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "2fb317fa395eaef63598c1843d293ce6dfde09833b729944ddea1b2bf0884ce2"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5bfb8792fee74b6c029fa9bdfe02388c05569686409e550ba39b12f55b9b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce2b6f10ea7ad3c1fa652ed6e9231b21edc283c1e64f7fe664fba9e2b71d0579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df59026f089beff036122522ce69cbe541e55aab351e1514937cc301a4e8d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3e9dbc63e7ae31610867eb68a0161c6ed20884c86551e8d2dac2a32be1dd067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec554e8bc2fc2301e2d8c6b545c8432704081d2354d81c6ac4e73bf23e1e32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac10a431526011ff81dbdf38d4d4bf444a77b23140de1f67eebfd1e050d63a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
