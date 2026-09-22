class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "b3d8d285d0accb4062bd47cfb9f6623a8b97c424193ff260cd5aa46cd14bbc40"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e303ac65ef1cc81f777d9c141f9a237d22ababb23114a27bbd8c89b7eb7af86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e303ac65ef1cc81f777d9c141f9a237d22ababb23114a27bbd8c89b7eb7af86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e303ac65ef1cc81f777d9c141f9a237d22ababb23114a27bbd8c89b7eb7af86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5f92ed83ca2fd0a03887f8cdd922c70e8ce48950fceec17053d07e5f20ea7a7"
    sha256 cellar: :any,                 x86_64_linux:      "01018b943ac1a1cd6625f0d3bd914730e9393d6bea05c10e72a4b7303e8e5f24"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra)

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~MOD
      module example.com/hello
      go 1.22
    MOD
    (testpath/"hello/main.go").write <<~GO
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    GO

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
