class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "f761520494e514966ef95ecd085f55d6a479a6a746e2b553ac9776fca983cd0a"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705d3764645b7d0b1815612519fb513f79a26199dea851ab296586043fd19b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705d3764645b7d0b1815612519fb513f79a26199dea851ab296586043fd19b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705d3764645b7d0b1815612519fb513f79a26199dea851ab296586043fd19b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb36d6862854e138b99df86cf74eee81f01e67b34c771e25c86f09d9a21d6677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e44dd33ea4346bf2c300ce6911b814fd71647595cf088d83b4d0eaa773bb48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd843379c860581f873d27ec76baf068e72de600d57141964a64f1d8c3241087"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
  end

  test do
    (testpath/"pod.yaml").write <<~YAML
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    YAML

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
