class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.340.0.tar.gz"
  sha256 "c235ec4cb5ab8ef8cdc2eb2de414c8d2ea2ff20c3dc2026d0606923ca1ac4976"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c76c4e80b8e31e832daae73f95744fd9b0a473240ab557a4f0ded90e182761c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc94c27c7dccd3fbfa050a0112f6d309f7e6441c6f79a54011ee89f6d7543c9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bce90171e6286a2c12efc9312552f49b1cffc052396d3b3b108d1bcdc90cddfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af5b857a3d5836492a632136b4f5a56a292c3d3cd4c97afbc50709109147b936"
    sha256 cellar: :any,                 x86_64_linux:      "fa440759782b7590a757a349ed9423b0bd0b61b4476a964db8ca70531c2fab29"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
