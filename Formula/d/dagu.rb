class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "34d426ad33e03839eead5daf394ba93b311571a45187cfffb64ba379e16deede"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1eb1685230a715e49983459996dd1793bde07a30d0f6aace6c895c990c387d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a15971454e6b507324e21e70c96ac7e83ae2b4c27179d0584a2c006863be65e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e323ebe758f553a817faf218d0b96c3cf0f0a2689ffd9014b16ce4c6ad8f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f697cf6fde7813ef459d820b5731fb22303f06bee2e5e00f7afd0198acf7d829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4db943940f49d8a155a8b117badae90f7a4125143a9bda8fdadf86bc79c8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a8396f20db00110e9594e90ee97f990e4947f8cfa29c18724a26ce97b07e0f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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
    assert_match "The DAG completed successfully", shell_output
  end
end
