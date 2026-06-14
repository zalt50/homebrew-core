class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d93336722b62d01598d28ad1ef707508925953315cb542eef64935d6093f769d"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31db0aa7f4ea3523b2d95fbf7d1ae1301e2d6f9b342f5d90592d888d2492f5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31db0aa7f4ea3523b2d95fbf7d1ae1301e2d6f9b342f5d90592d888d2492f5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31db0aa7f4ea3523b2d95fbf7d1ae1301e2d6f9b342f5d90592d888d2492f5ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e1a5545c2fbd910e448998f6e63b728d426d499a4760242d0be5dfab5b2b85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c03f53eb0a0aa9c44aef00e965bc8dba411907c04f836419ac4292ab1ec8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d323fc4ecbf0c6dcb8a607e348c05fd9ceeed7ab796eab5b9f0e5784b10a65"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
