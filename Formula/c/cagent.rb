class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "dd763609c7d8f9707d91e451d33e3d9917f99bad51e00aa267e1e97c0abdd3ef"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6f346ebd66ba16f75df8c42ad14e5d6de260af1db1a6dbe373d06ffb18b74f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17844f9a09a48cb6c5e99356f8279cdb140f79760a06b44b91f9c301363acab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10845c098945a19e08f3edebf1ccdda76986085375f2645dbcf37822f512599e"
    sha256 cellar: :any_skip_relocation, sonoma:        "75ce05dd4142537fcf3df9e3a82431e13d3491077f0039391c187ac0ec495c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51fffdecb6282c277d88cd41464458a782d40e84cbbae631715b24feb0707f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec26a5ab117b1a8ba079871c2763b29df3924a29ddf0571ed427d5d09bdfc4ef"
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

    generate_completions_from_executable(bin/"cagent", "completion")
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
