class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "240c518c8efc8efb4ef00b9ff9ee89502198a5e922b9d667deff6d03f747b275"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d100213cbc5a7b259df8e05d629759fb2fa399d5bb5fa5b0b810d89d73c933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d76596d929ae6ea2fe3241b1b413ef2cb46f04dba0dcefcb81fc44bf52ba6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781f1553b3f37b7e9fbdbb76f32a6f1e467be0cdb34e5df75d063ee6c674dc6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a215cebc6d397e7a1bacc38f9604383fff1f8c8f1bc67f351d806511ddb30d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "798a579e36cc0fdd3a8bf311853cc7b9897e20beb2e2fc6053865e75ffcec14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e19492f9217265cd4b0e6ad980178b44b37be00311127d575ad2c0b3c79926"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
