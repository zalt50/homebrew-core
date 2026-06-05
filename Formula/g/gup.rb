class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f24d4ddb61e1fc34d81d5c384b8bcc1af249d31aa800a22cb7e30c1b7fd6b87a"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2390d9725806d7b9d0e6fee7bbbe12f7532bc9394aeca98888db989fe1c568e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2390d9725806d7b9d0e6fee7bbbe12f7532bc9394aeca98888db989fe1c568e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2390d9725806d7b9d0e6fee7bbbe12f7532bc9394aeca98888db989fe1c568e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa9fb237647b1fbac0d97b265cd4148ccad3a6ad49cb930ee776feef1d7442c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a929e3e44ab7f5c5e8976fc88a8da31a7beb68ccc8890accb8837aa879da76e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3e4aacca672f1319c31a1a1d8e95998ab07179e82687de710c8b04ae0abcf2"
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
    (testpath/"hello/go.mod").write <<~EOS
      module example.com/hello
      go 1.22
    EOS
    (testpath/"hello/main.go").write <<~EOS
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    EOS

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
