class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9bb3e87e1cf07019586c201665cc330dd0c9c4bc3bbd3f9837f183267c93c287"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c20e2616d839e02b14eef38c4586f915da834fffcc45ff2667ca0d9fe862f2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20e2616d839e02b14eef38c4586f915da834fffcc45ff2667ca0d9fe862f2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20e2616d839e02b14eef38c4586f915da834fffcc45ff2667ca0d9fe862f2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "a539ff1b9d4802d2e094a6c765452a3535f75109bcae72f82502af4ce6131e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a151836c189b9a783c63f09a819d7147575cd510ea98f129e4e2f1a7da040082"
    sha256 cellar: :any,                 x86_64_linux:  "250cea968fd3efc21d22e19d5089b537fa3c01573f9fa78362555037c622917a"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
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
