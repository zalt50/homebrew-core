class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "cd76f85a4a1664769521c870985ca12281c8c1c195d501430f80049ae59ed37d"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8db1dbbef5153721bfd2b7433066140b47fe75534236e4f1f76b500d2d41b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8db1dbbef5153721bfd2b7433066140b47fe75534236e4f1f76b500d2d41b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8db1dbbef5153721bfd2b7433066140b47fe75534236e4f1f76b500d2d41b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49067d58b3cdf602dc8fdc532334293358e0afcf3de42f20733df16906651f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1479a298af9d8205d42318c5eb61145d93fb964e9046776ba38445393c176483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba3b2b3c64d6bb58debdb0b30bd7648f21627e85e68f84e994b16b874da46155"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-s -w -X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
