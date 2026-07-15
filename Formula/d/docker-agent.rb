class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.108.0.tar.gz"
  sha256 "2ed1193cef7b8dbe898632258dd799fe9e3c8fee0fae71feae0fff41a62facb4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d71ea9dbb7d5c5b5286f94918cda120e8f491be666721239408fc8e9534b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa309ec0f10468121bc307a4ecc7d0fcfb2862335a403df74cf666131b1b1b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b9907310b852f17062601960913870cae39a3d9e3ae557e2bd6248e538092a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3f9e8440659cbb90fdb0ba6bf2233e607eb5fe48e7e3090efae1e15745840c3"
    sha256 cellar: :any,                 arm64_linux:   "f7e0788e426f854c9abb618ff3f2ef858cd5af1f458b310d76a40094e38cff58"
    sha256 cellar: :any,                 x86_64_linux:  "8254700a66e369c75c9adb767ad72ef60ca2ac78cac7c4b57be697bfe372ad23"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
