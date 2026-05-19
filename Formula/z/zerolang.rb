class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "0e8f91f9e5abc490488504f7e878a1b042c6dd432e693ec3bbcd5acb248f83e4"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9355c5915ebc91d1de391d1db9709630ad86ea5caf235002093165922b2bc324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b165540f83ad2069b026452758db96f21f464c8f36c539ae12cc22380294d612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c193cb33b43de50d2784e259260ffc4d0ae32f9b20bd1617d87b104afa7acc4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b02fcd8a67537e487cdf33882da74f375e2dc37f34b8a95017ff615fa95c72fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2affcdc77c77fb1521334c1a2595b042a02f6cc2a036e795bafc9dbc217c08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b07f908845ba1e3c05d14c98caf32419529eb32a6dd92e919df1d291029d564"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~'ZERO'
      pub fun main(world: World) -> Void raises {
          check world.out.write("hello\n")
      }
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end
