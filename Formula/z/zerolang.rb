class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "69b914820adcfadd2a7b675d429fffc5e74602ceed555082b8406feecd77d653"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

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
