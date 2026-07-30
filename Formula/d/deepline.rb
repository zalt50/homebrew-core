class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.320.tgz"
  sha256 "fc33cb69872fdb40b897053fbf6774ebb5a732d8c96b3eaed2603ae3968bcee3"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4de158bd129a1d7cc40d6558f49cb7048843b5ad7ae0a493928bd62f12d12aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de158bd129a1d7cc40d6558f49cb7048843b5ad7ae0a493928bd62f12d12aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de158bd129a1d7cc40d6558f49cb7048843b5ad7ae0a493928bd62f12d12aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "424d0c5cab5e1256c2353a390ffaf4b7d1cd6e15e6a41896f668eba2a170bc06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5890c5406a27ab150c5d8827468a1f15b759767ca63679116ba8f46cf6dfe79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da41714ccd53f3fd947cd0dbe5c55479b4d51f4d045fd41d02e665b3fdc13211"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
