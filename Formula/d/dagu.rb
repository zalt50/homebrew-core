class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "ff33172e66b1b6633162bdf70434d41621e4f91588fdc8a3b1ca1438a5cedc60"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50efde9502f0c663c9817e140956059709d1bf54f31ca2a1fb0f6d0aec9b629c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb7804e291fb5fa53313d2d53cc6fd9f00c89033c822390abb0426eb0254526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17cd8b1ffdc514523ccf72d9dbc5ca672272e887fb919ac5268425f1704544e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "98df2aab906094038f0f8438fe4543a8aa014a0a31de9c769197ee04e8c9cf3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9317378da286f99ca5a43e7c382099e609759c9dcb9beef9cd322660fac97b"
    sha256 cellar: :any,                 x86_64_linux:  "35c3a2d6a76c2cc76f202f33e920936f3900ae48e90ce286e11d089bbd4964c3"
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
