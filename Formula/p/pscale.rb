class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.317.0.tar.gz"
  sha256 "1ff5a77b7f0543eec38974df2974f79fa4dab08ffc5a836d7b22883013f5d424"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1af9644ae87d089f51af6eb234f6dbcfa867cceb7992f1cc56095fc90653a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0936dad5986130b9286bb10938002fc8eed8e744eee64240e5b682f2fecfa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def0bcc5aa44e98f77153eb486a092d8e5a0414d01daeeb4df39224df0f69866"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6e93396cdf4a1b3408e2a209281f5c0e5ae05f3f0535b2f0116be71bb8d8a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d9de5b9f7bd7c24e367f57688f0b1c489c35d40de9e9aa5d7ab44c775a58990"
    sha256 cellar: :any,                 x86_64_linux:  "8ed31fee6d43633aa4f50c3ee0593451f94fc229083b404bcbb787b617db6704"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
