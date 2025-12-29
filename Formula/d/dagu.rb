class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "7a1f650478fefed9e0a959bc199e690deef64ac3b3bc56720fe0932ee2651b78"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d531e705c1f1d745956ae99f05ac14bdef749679f12c3d4882d2616bb7cc167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166d8f40a1b975fa3d5c8deb8c7d0c7fb593acab419fa9fe8c4d91615a08e286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5002242f2c0d384c261e72c46f109ddf02b82a0f7842cfea4dd15b9c5e4d75e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "503d4efbd6e2e33ec9aca2cc0b4db49e0027ed4ab71a4f2392b72ddc0882789a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7b730e2cde8b808b4e7386090002bfad2d69644c2c76388ef8247c0698bbc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b252a833078130a7b8f75e31f193f7ee143807c6e36966e7170e91a8b200bd54"
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
    assert_match "The DAG completed successfully", shell_output
  end
end
