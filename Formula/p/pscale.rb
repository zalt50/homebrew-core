class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.321.0.tar.gz"
  sha256 "fdb75eaa18eac8dd75fc2060e61e3081cda85a1ea01332817cf37fd4a61587fb"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93bccdef249cdedd59ee63ccb668f4ce657b0f5864d5a842252bf686453ef1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82e1f85bf6ff0879938d108bede378320a207345136e42ea99c34aeb8d9f8ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc67bea16210202fe238a52998d8f7e12f12a21f8fa599e58719a66e805309c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5810532541783148a8c031710a64e679e022d1c5bef9c2a038934dcb7ebb662e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45dba667f6aab2ea88d4481df1863913252c14c960a8b191ddca960b0c4e8bdd"
    sha256 cellar: :any,                 x86_64_linux:  "1d2bec4d9fc9f16c7952a36d8278151bb4dabc81d57530ea2ea86ce8c947834d"
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
