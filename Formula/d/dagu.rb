class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.14.tar.gz"
  sha256 "7bbe016e61483f46f760af9a7011fb8d8da53ae189ba03cad3faa07fcd9b48c6"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcafc8197ff972f45222d9c0aabace51b8e5b0817f1a8f81fb1b0c50aaea4343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "455535023acc93c7aec1c66d126749127d64099ada2e3a7ae1becbd6f1395537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73db6af5911fb364c1ee301d765117be56e305ae41f7813a10114a3f2854ab4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0012a281a630114de1c6b9d75fedaf2092f5efbc9d42bcadc5e7df810e5e454a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f513b666cdb94e253e8073f9a1150c60fc04f125a23ae8b9fbfbaf8f4b225f2d"
    sha256 cellar: :any,                 x86_64_linux:  "97a7003c1ab247bb24fa78f7c9a9f47377447aba940206eaff8d9b8d4aa121ea"
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
