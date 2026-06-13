class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "222c6ca439103441c7c2169351b0aeb841c6f5eca985c07dc53f131173e5c2a7"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fc71d4f6657df250145563f048b292d33f6edcc25ae6601cf7ab4b81f853366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac99ca2b2b384aad770151ac408e15b305a43085e78c9a45c5aecb6ea1a22a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7cd68eac13148fa63a68a2bf7a15b37a77f21d4e18442605385a1050e2273be"
    sha256 cellar: :any_skip_relocation, sonoma:        "00afcb902d7e291d48349617bb1ea7cfe32852d3d08eabe16ca17e414adae60b"
    sha256 cellar: :any,                 arm64_linux:   "5b524ed12fe58e8c39edddfdfcd06b3ed69b6044493fb07dfaca0475cff1fc16"
    sha256 cellar: :any,                 x86_64_linux:  "8f9579c7dd6861252cce38559142f4bc5aaffd37ecfdf2d3722ba1679fc20193"
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
