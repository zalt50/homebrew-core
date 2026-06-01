class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "ad66623818c2ad01b20d2c799bc888a631bc8b84d4c5f6ae67e156800453f99b"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5994bd96e30914de5b63e748886bc5a8d352201cbd406353ae68853c11d7a40b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5994bd96e30914de5b63e748886bc5a8d352201cbd406353ae68853c11d7a40b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5994bd96e30914de5b63e748886bc5a8d352201cbd406353ae68853c11d7a40b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9955b6f79f6f880b6113419f2a484349f7b8d9aea4b76b223f07bf28ede71e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f171bab3a746cdbd4903e7b44318cf1d29c42e440d9f0cbbe480164357a1a2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5c2631295dd6f067ce3ed5ebcd9d70319af1fd33cb91002cd8a9a714853de7"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gosec --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
