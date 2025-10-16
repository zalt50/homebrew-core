class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "a93deb1f9f1eda822b7f204b0809080b650b090082eb0cef497368302379e68c"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8129b018a65b979a9d624ff37936864d9f8070e39e6f23e48b7b5dfaf918ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3742f95a49defe2ae42215f4589de42f3cf05d5962ea87c47899952f4874341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ec8445be4fd971290a5e9cf57d32c3bbaa7b3b7ec97dec5bd4c8ebd4be2518"
    sha256 cellar: :any_skip_relocation, sonoma:        "640dfd173f410727b086dca7f9d3000e3ce5605b72ccc0ab866b0199104900b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3d3fdac281c6121397f63b642a9b8fcee3c61ebdf91e5fbe1ad2002d607a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d2f54e00921d6a0560d11af22f1c8c6271b9d0d543537821939c760aa8a470"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # Version patch, remove in next release
  # PR ref: https://github.com/microsoft/wassette/pull/402
  patch do
    url "https://github.com/microsoft/wassette/commit/b71d3a26c568342dda5cca0ae502739dca2d1b95.patch?full_index=1"
    sha256 "87fb20240f450d7fb24f8ad8af43e340763865c42efa0cab27c7b8ed5b1b32b8"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
