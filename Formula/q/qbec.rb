class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "52a9c7f0808e418943fe68e7cb6a062f7718cad3f84f4c30ae2f7605366130b7"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a547401ff56eb2046826e2731d883411396f23b296245135b7531755474c21f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db1e6307ce8e2e6c316d9ca7a89aaf4fef8c7bc3ef2f63eb77f6a656d0a261e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b6801aaec1b78aab8c00701dfafa86808f50c98ab04af9c17b69e52bdfa09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9417fe6ab64734e23d73b5a5e47e3416276049503fb04ef368cbb35b5e9398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b372beeb5e64cf228b2ac11b67092102d011dcc14d901725db8ec4eb57916d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848b55a3a8d620c2c8976eeefe63c885c537506ffe95080ab2b1c0e9788b2c43"
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
