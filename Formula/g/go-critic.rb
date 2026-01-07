class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "baf54665063087dc48d2261822229a3d8ab670fcec38fc5e25cd6350732746cb"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8968aa102678253312373087660906b05d866524b8c23cab03c02f13c6ff98dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8968aa102678253312373087660906b05d866524b8c23cab03c02f13c6ff98dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8968aa102678253312373087660906b05d866524b8c23cab03c02f13c6ff98dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd8f225ab72b4870e6265c3ec52a8f3ed0d7a6244c2af8251bd67563f6d6735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131adc554aa4e3c23f181a090d0af56cc012f7e7488cd2e268df08d4813818c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681f56e299c9ab661e57fc8742f3ba3b1cdc37cb2a8f994bd6ec5f3a1d33e2c2"
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
