class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.103.0.tar.gz"
  sha256 "27535c95a184f5546cacba8c550d60dc3099f3c286c7c08f1b58d81319dbf0a2"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ba9a1f408a33ae2ba94f9f0726f54ee68da6d707f624ed41f8cb88d24a2951d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9362733618065e5908fbf78a76022bd0f80b8f6d21998f5b4beac4b66d96d9b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1082d3de10c17063987cc32f3143abf579ad657c8b61f1863b7acc2cb8a2e026"
    sha256 cellar: :any_skip_relocation, sonoma:        "620140e246fe5205c3982569e59e60537c6b98605e59d3c32a860eb933c69c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c21241e4739e9b4120795bc68086d706b066a86e852823c3004ae8efd54563db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b522832062c98f192e2cb7b7691ff8833f31bf08a57cee4efa6fa62b351ae7eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
