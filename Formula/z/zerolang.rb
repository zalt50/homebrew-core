class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "235f04df04cf6b85eeac3779d40ca5fbbc8d68e6e34a8cfee8d6eea6760e9320"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e50c18ef87d17ada36cc3c0667c76d55fecd86833c46a7771206e09a8f788c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06f2d324418a053f36dde44659066699e6946aab62dd9e75ce5133efa6c0c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a083ee7659958b6785dce3f82a50b23d6743399e3a19b2458a4f722e4896d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf4986382b00f92ea8a9006eb06b60d2d77b88111b295df887efe035642f7658"
    sha256 cellar: :any,                 arm64_linux:   "f4d13de37330b62882c29be95a25e9ea106db8a3be51244534b3ce20bae35c98"
    sha256 cellar: :any,                 x86_64_linux:  "37717973d25434fa27c604cc59805b23ed31afc185f2295c3d49edb899b255cc"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"src/main.0").write <<~ZERO
      pub fn main(world: World) -> Void raises {
        check world.out.write("hello")
      }
    ZERO
    system bin/"zero", "init"
    system bin/"zero", "import"
    system bin/"zero", "check"
    assert_match "hello", shell_output("#{bin}/zero run")
  end
end
