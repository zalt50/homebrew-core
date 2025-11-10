class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "cbc374ff977943c6e7704ba9ed5fcd6f914d295f06c8f02319d0e24acc729537"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbe70dbfc7ab0a1e5348feea7e1a67ac42cd56167c3335a2e199d1f1465dadb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d9a12cb4744d22558cc454ebefd6fee23365c90bc68b67e4bf2e5322685bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1144a32d14a95cb06e872e77e7bb63f6baa15c9b65021fe7bcb5130c2d4edb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b25d80b9ec43e26a9e484ef0609dad4a6cec1024a7adc182e0b380875348f51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4467b99359581de59a5e67987f4abc02167a33eae2dc975931cdd6284a1f8084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746ed9a34d29af2c1258ef37a53f0f80ad823598d17c5e6bd589b806e02a50b7"
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
