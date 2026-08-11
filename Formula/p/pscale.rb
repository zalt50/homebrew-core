class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.313.0.tar.gz"
  sha256 "f0b1642e084a49a10c3c4c364ca804a81a1d81a01d0ac08d86db2f22252c96e7"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dd12c7a2c548b5bad6800723457933fae93af697d53d87a6ff72ca6d9e2b3e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc5f3b1881c92d8396721c3af65602c8bda9ca8db855fe81c0a1a3b897200e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1671351b68533fcce3dfc569e479844dda79086009e684b802a42939381689ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f8361bbe9d39f71c6149583cfa43ea08d39b1e285353c4cb14c8471b96b0285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c94733eb165daf5073c45509662a9185d3cea2f9dc8fad1e1507c69ce6e3992"
    sha256 cellar: :any,                 x86_64_linux:  "53c59b35dfc71973d79c362d8c88ca738e66262904f90816fbd48512dd6b54e4"
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
