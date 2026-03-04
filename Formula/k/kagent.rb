class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "f9e759b4358dde59128a614728ebc00f1b8c32daeb19bda123d29019b6a9546b"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f76c83d84bcdb03c594877b1a605a09e1efd433d99ec8741981b1fcce88f036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f76c83d84bcdb03c594877b1a605a09e1efd433d99ec8741981b1fcce88f036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f76c83d84bcdb03c594877b1a605a09e1efd433d99ec8741981b1fcce88f036"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a9d5570ff4b4c89d7a497527c51dcbaf3ef7067e989dc316453ce8a8f4187f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f715166d7fe50b1cdcbd050de51c7198bea75ea3ad6d5a6e67d0157471a9ca6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a204cfa1d7fd893324d7f8f00d3c7519b51074194fbc8b7740fc110824f4a1ca"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cli/cmd/kagent"
    end

    generate_completions_from_executable(bin/"kagent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagent version")

    (testpath/"config.yaml").write <<~YAML
      kagent_url: http://localhost:#{free_port}
      namespace: kagent
      output_format: table
      timeout: 5m0s
    YAML
    assert_match "Successfully created adk project ", shell_output("#{bin}/kagent init adk python dice")
    assert_path_exists "dice"

    cd "dice" do
      pid = spawn bin/"kagent", "run", "--config", testpath/"config.yaml", err: "test.log"
      sleep 3
      assert_match "failed to start docker-compose", File.read("test.log")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_match "Please run 'install' command first", shell_output("#{bin}/kagent 2>&1")
    assert_match "helm not found in PATH.", shell_output("#{bin}/kagent install 2>&1")
  end
end
