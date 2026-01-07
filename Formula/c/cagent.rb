class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.18.8.tar.gz"
  sha256 "ccac1ccd56315afaa776aacf7d06af24dcf1409f7319013b600b076b28d26625"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc614c5109d70b075db0dedcff1f21db07aeab9a7deb39e5cd58fdbe46559c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2642c6463a6e19ca66f510683897ccc4483de3bb9321ae2f953a5b71b2b9d86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7bfbe544bd903195daeade79c260614a65eaa96811108363ce3c1a3794a2e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbaababe402f75a33a137de0576833854d2cb03ba2e1e388cac9e8e60b83d9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f6ea54400e572c88a2bdd278e304a39cf06acec42b875059ee4b6ab26f6eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d08984cfc19e7dfb50780ba88192a7177b4003b128491fc22800e9a1063377"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
