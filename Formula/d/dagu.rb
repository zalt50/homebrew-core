class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "8c433dd4abd3dc4a928fcec1ae90e6570c6047bbbb738a5ae4d069a8c8ed350c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "076dc2e891bae5adfc5c0ffaff70b0f321ca679dbf11a078863ebf3cf19ae082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa38e8d193f0a2f2338a9360d9bcf43918f8b59fdb80db4a0cee01b28602cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ece4d418cbd56475f2b9c78773b156179eacfd09401f8bb55d3a40768b75054"
    sha256 cellar: :any_skip_relocation, sonoma:        "08063e0dafce523fe9c8ff0e1c309c5836236f156912593193a0cedb5f674ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85433688e501e8993279ff3daee6c913742b275a5c49bec6e40f4590fc10621"
    sha256 cellar: :any,                 x86_64_linux:  "bba8fba6f6442ca1059262823482e4ed907ae50f8a1e6c9a02e3d0332fecc5d0"
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
