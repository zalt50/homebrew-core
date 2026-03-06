class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "4260c9ce325b056a470a91b837f73fd0eb8b675b536ff04d59d3b427ebeb2d67"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65a57acdcd60ef6c485914e81e776b7a8d4da1dd467050b77ca8f84111d00bda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a505f7ae9abd24b8c721d0ee0f229b76bf00527dadfbefeb8f60c2bf6b2e332a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d0c39a004f24a1111ad8c0e97947ee4f10749a490dcc70fefd118d603b4cd0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa208a10ea0a30d4b0dcff48a8773da9ab2d50015ee904ea5589e4f4b4ffbfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c8ce32e221e73f5018ce2316315313a174ef850d04cb72a98e2e18b74eb0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de216bf8916d2b72d3d5696086160e6413e60d169ce2ac3f3fdeab87e8393861"
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
