class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "ad66623818c2ad01b20d2c799bc888a631bc8b84d4c5f6ae67e156800453f99b"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef05c05124754bf1bd082a0751a4a55ef96df346070f02b53c10fbe9178d7982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef05c05124754bf1bd082a0751a4a55ef96df346070f02b53c10fbe9178d7982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef05c05124754bf1bd082a0751a4a55ef96df346070f02b53c10fbe9178d7982"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b3e58df94d0a8bb6aa06d65894c059433aed078104d2471c779a22f9ccd2091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e8a265e7084f19fee38d14e45bd0f7372ef484433affba5431d1b44b74acae0"
    sha256 cellar: :any,                 x86_64_linux:  "72cdbcb7b48d93e14adb4d515a7b4cc57026bd573a1d9b45673665abcbd0e40a"
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
