class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f2b2bde6cb70e6721f776214bfe23f36bd3f1ee3ca0ec1ece88cd15da7ac06dc"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c77c35d81dc434e559c91335d16db70dc03b7e3457643a9619d891b9c2056662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a40d2ba288447e6beb4c2842382fd52ae15cdc9e6278106c242bc45df101906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d2c5995130d46597f74bb6dad887ce04bee358cfed295e448bc6c8abe147a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "89ed4139bfb7325445a5eb720526cfe36c7e3b7043abb6bf069216762c95af0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df7d0791ba77e3b53b49cdc1c6b3a2e0e2c399b50801d24d82a4e7e9c2cb01fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24ab6732e83b8e221105ec3e73e8b696e5f1b00f7ff8d5a352ec3088149bcca9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
