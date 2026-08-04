class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.309.0.tar.gz"
  sha256 "c4775414c673356d9f68496102bbadc469d716c2b2e227e6689b87a0efa1fccf"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0611bab2e51e88426fa6e8c2eb31b94cae8b1e018a01ece24d01dd712f0badf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "145aa4e131e9304c932cbdb4024e2a84436fa9f0bc415ab0360a98a961118b46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b311dfa9917f5acea4383b4a7134aff9f1a063c6891d0015d4c4fb2976d84d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c33c8382cea7b4f916a2166ec98f30564ecbc126528ecebf9908fed5f7a01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54653302f81f2df764ebf5858a37aa514df9e9b5db819cbe17194cbeb8e869a0"
    sha256 cellar: :any,                 x86_64_linux:  "ee053de091e97fb06b2d80ea657e022d5e9dab6b4b5c5069540a71b0e798f8ca"
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
