class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ac521634e858a053d84dfa81f978a72db5c8d795ae49b471eecdfc089bca0294"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c38be262adbf2b5501d09910a53fab161587afa9f90f6362383c1405868931d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c38be262adbf2b5501d09910a53fab161587afa9f90f6362383c1405868931d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c38be262adbf2b5501d09910a53fab161587afa9f90f6362383c1405868931d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9546cf8f0c7c7e5e25bb3d98635d014fabdc1771e83856711ae2f64979def01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b403f874435042976b91dcbd7ae0e48b416a5eca8ddf3c9f0f2a800a51e6bdd6"
    sha256 cellar: :any,                 x86_64_linux:  "6412c00ceee8e57fee7826df60826a6c8720248262c991785f141c3169281829"
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
