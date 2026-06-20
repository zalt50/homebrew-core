class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "bf35d8b474ea7cc7b229d6da07243db6b6356821713299205f9d30692f08fa77"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2529b794bc82fa13a9c44f6edf98d0f52174d99c5c726473d0b5896d6dfa9ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5309b2c7c2938b2dc7dc3711922cc836949ac9f2933f9aa3a681e9dfc40a86aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "750450e454c616b251927b6a084ed24ae986138ca93365f7b3cfe09910e3bfcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c959ff28ce7b7dcb8ca10402d343443635b2b8b56c9a01717bddd691726d1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c5e32316f3ff0766234865a6fa221fc60110bf60c50a7d5b685cd2d318b991"
    sha256 cellar: :any,                 x86_64_linux:  "255c018fd6ea63b6b5011a053743754438d327138a4cd1edf7bbc1e080fbbeef"
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
