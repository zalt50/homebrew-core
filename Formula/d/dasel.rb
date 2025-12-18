class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "d6ee6615f0dded31dfa632b02901fde5803b192eae658d01d1c548a0f6da7491"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37933e0dd89b30937024350bf396a844502979aa4d2b04884e5f79467bc98b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37933e0dd89b30937024350bf396a844502979aa4d2b04884e5f79467bc98b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37933e0dd89b30937024350bf396a844502979aa4d2b04884e5f79467bc98b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d0bc7cda0cee3a9a241d40b9a7647b803f4d999b683d476d0d0d5311f46cd8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327b6a208ca23d43d61cb80477fb34a335301d86ebaf7f5f45257c681a80cdc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf55017ac90f1cf4d6224e9530bdf71dc3f6bdd71bf06afdfe0c2527394ff90d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
