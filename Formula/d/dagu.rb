class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "8eff791a9069c302e83a0baa2f7883853d2083b74f2e06048ec754849abf30ec"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4d6e16ecf77e326c1c55eb39bc1d47d24925daf1a4bbc0eb033d97588a4f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a7c5e692f49acc2e33d781cb1e446f69c6eae673be5013ae1eb8956d2e76eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab00cbfc2becc9a59e22fcf5cc12a8c589e1f6088a1c7377558457a7dde252be"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dbd78afda292fa049c76edd00df255f26f9177a604a47069dd88a23c2be507a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc20867e0e258585be64d24f2a496040a0eeacf20e9c775fcee630d85b210ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10ebd563ffa857a6a1defc6078aa2e07183183f2f93f6978e8b796e59d3b647"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children
    (buildpath/"internal/service/frontend/assets").install buildpath/"schemas/dag.schema.json"

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
