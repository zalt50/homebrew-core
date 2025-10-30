class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e9487c5cb16dfd2d6d6456b95cbeeb40cc48a1da4b5be7c5cfacdd0d12902ec8"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2233109a49940c10596ac78099b9dbf1f8d4df16381ff2b8b3daa6b80bcdaf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2233109a49940c10596ac78099b9dbf1f8d4df16381ff2b8b3daa6b80bcdaf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2233109a49940c10596ac78099b9dbf1f8d4df16381ff2b8b3daa6b80bcdaf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69c05d4c0bd7fbb9253a537161daa273b42c6c2da469838717b457ee428cf60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bfa7689a66bde78abc423d581012fb744a8b26398597937b52b4451250b56fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d87f63763c79f16a57a2e7b36be49e49e360b469db110d663ff7b426405e18"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end
