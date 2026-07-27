class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9151983838fa3fbca5a83e3b302e81c68c61e393cb9d3b7e4c297df311bbf394"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e850602bcc582dd3614973dd3b21ab9ded99480fc731c3e9f545dc47abb2c699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e850602bcc582dd3614973dd3b21ab9ded99480fc731c3e9f545dc47abb2c699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e850602bcc582dd3614973dd3b21ab9ded99480fc731c3e9f545dc47abb2c699"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17286157c80bddfe79f1773365b13f46e64bcda6decdb2d809b5f22140eadb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70db059495d952b95cf72e49c5d5976f1a213d6dcab0380bd540910ce0c80f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac66368cb5d80b7a4b807e9204b1e56e5e2d5668e411668b4a2ae6c920f67cf"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt -version").split.first

    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
