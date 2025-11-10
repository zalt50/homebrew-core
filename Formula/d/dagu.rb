class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "15c936459f19febd36aaea721acd3abcc9db479725333e929315f2fba36721cb"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a1717535b0e0ede40a6b982641f640b315b39295ce557231be9a3ef236f80b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cabef5066a858e9bc745ab23fd686eefc60d9db0b45f765828d58d4573e2fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db5fa667c4fc56457d45cd1518b41092fb66c0058768a32c3344e3b0bbd0e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "a099d3d6694aae7e4934d1925c26464563e55fa1d341d937ca34973e801fe39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a54039a3818b2fd772b3ff3e7648fcbb615846ecd499ce116c64bb468f8e167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a764da3703e15b344e469bef28873c4dd6ba30ab15667191eb42a16c84788612"
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
