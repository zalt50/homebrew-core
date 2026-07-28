class Solod < Formula
  desc "Strict subset of Go with transpiler that translates to regular C"
  homepage "https://solod.dev/"
  url "https://github.com/solod-dev/solod.git",
    tag:      "v0.3.0",
    revision: "b4a71c0a7ec37a1657938f262ad8fa9bf55b46d4"
  license "BSD-3-Clause"
  head "https://github.com/solod-dev/solod.git", branch: "main"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(output: bin/"so"), "./cmd/so"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/so version")

    (testpath/"main.go").write <<~GO
      package main

      func main() {
      	println("Hello, World!")
      }
    GO

    system "go", "mod", "init", "testproject"

    assert_match "Hello, World!", shell_output("#{bin}/so run .")

    system bin/"so", "translate", "."
    assert_path_exists testpath/"main.c"
    assert_match "int main(void)", (testpath/"main.c").read
    assert_match "\"Hello, World!\"", (testpath/"main.c").read

    system ENV.cc, "-o", "main", "main.c", "so/builtin/builtin.c"
    assert_match "Hello, World!", shell_output("./main")
  end
end
