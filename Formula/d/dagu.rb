class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "bc1fc0a74b91f28c6026108029acef1b5c3be505f619b0cda16305f505d00e45"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4945c4c6786200716e24f4d6bdf22514bbc41a2e6b52d196b08d800d766bd78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b64dd601ae3aaf1050bde211abf20da9288350ce0f13d84033e45ede76b9c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30dc0ad0efc2ff3389f344ea0ca48b6177f25b53f54addab5aed406e49237f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "01e0ded2ea8bb9f69f7d2f55c3cc2726c4e3ec7eaaf2072e4edc24e7fd42e4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66f30ef6f7457575fe991acb166be23215384f16d07726a9995efdfed4748b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95adfef7905bc3c67c34a9d43b9765dcb856a57f508aa4c927173da478f3e34e"
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
