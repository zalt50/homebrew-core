class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "7354b18310bbe79aa756573a76527265ec673b45d8dca95b304fcdc4d790e9cf"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56472f7d426644e18e36bf66f61583310343801dd4ec289d2173aec7c2f15afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9fe4a747d55ee24d5ac18f03af3db18dc81d683a046a038526eb938f9c1d149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8464604f9b8fd7c0860f1a2bcac07dd904aa5a86f470d88166de845ab4ec3422"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d42d5ae0252e3b73a6483f99dad54c3a32de49cfb4f4f011038d4cee7eeb0b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8f57f805b71ee07d203b67f331fc5719c86769e1efa22add9497e3b6a50fd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1173730de4b894d44a765afccaf321f34f0ef78f81ea07fbdc2320b8389955"
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
