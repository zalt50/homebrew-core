class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.9.tar.gz"
  sha256 "04cfac019e2820ac2e7407f9ccedd5bcf1b6354784592de5d1f21bcda6f5f9ae"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef63cf99d9e4e743104d1d7d5d54909b348a42f191ecbd63a5e57d0e4c973da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef63cf99d9e4e743104d1d7d5d54909b348a42f191ecbd63a5e57d0e4c973da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef63cf99d9e4e743104d1d7d5d54909b348a42f191ecbd63a5e57d0e4c973da"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e6b1e77ae1fe2fd48ba205b02604a920f999838bab0cf62b17429dea1db324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "443bff776001482c9e787bae490bc012e862c7e150bca444d61c7d3f35e52a85"
    sha256 cellar: :any,                 x86_64_linux:  "04dce44b1faae2d19779853500aa57b8e161b07acf89f2f6f2071d977c179676"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
