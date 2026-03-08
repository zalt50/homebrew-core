class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6b7d14154118818da7e93151cc69edce0fe35328e3b34814e8544d0ce136aea8"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34871217a625ca1eac1c0ffc0bd94a5e0e969f3e58653fe724db27eb83e750b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1a2f7f7fe7526722058a1aa5ef52d588bae2c5f6aec077e8e8c0fc46d8f938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bffaccc34543b96a857b80b2c2488334a5724e230786314c969c7957c360410f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c60fbee4481fe3d53d68306e0ba1c130e9cdcafd191642fa15aa4613bb2095d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e482b84076072b88a8a0b4943a9e7f80d31dd01d8e0910b3f4e5a9fbc049e92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157531a9c637bebef96596766a91c3ac17c10740c573200a141110d10caa1b69"
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
