class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "cbf1a2001628cd06595fc5b4fedc98e92916fcd4d345e8dc8c351dc70bde48f4"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b57d438ef1781814e1a8e2b994700915980445de9119c45194ce0c8643843d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f9f39db9312656b23341e7530649851da6c0abdaccbaaa1fd02a2247e723e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e370d6383a686657761787e28413a791587d09472cc452d2792a8125cbe26d2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8ec19bb689ac61cd224173508fa19d437881363039f8202525664d858cd5f8"
    sha256 cellar: :any,                 arm64_linux:   "efaa328bf06d42275e8e3f9acbc8850826e5af9543a5395fa03e10937c144dcf"
    sha256 cellar: :any,                 x86_64_linux:  "ac72e2e2aabb87ace3747d1fa4524d3144f3f6ee3456c2cb008ee0d08b2dbc5d"
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
