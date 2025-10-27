class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "eb2978084930132f590111d4689cd3d71d2499ab47bcba399d243c0d495cd3e3"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c497d7ffc1dd6366d39871c56cf3967bb928abe12480bf248b5c1f16ceb602fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57acab86647cb458bbc3bff5c2cea8ea8099385d7b05b3a01eaa49f9b5741d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2f5ab0b42926b68fb3e11ac2ecd14c2adc187465d0a6db69e51de07a8872b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a270f13e355ebbe3d42af038dc52f7764c7635c26a3fe9e157b2c96f821e8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69960e55c2bf99dcd5f8785f9d450809c367b288bbf13979e61a9a8503b2c10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f4636db805f39effd8d32308c8194a8852f197cae9d758d4405914dca9e30f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
