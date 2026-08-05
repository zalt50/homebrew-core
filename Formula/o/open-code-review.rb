class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "91229340a3f66da8e91d39465a1fb030afa3edb298d279f644527509ea45e044"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "785214bb0bb3e12ff54b5ec96c66da27fa195176532f6a890cf3dcfb5267c82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785214bb0bb3e12ff54b5ec96c66da27fa195176532f6a890cf3dcfb5267c82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "785214bb0bb3e12ff54b5ec96c66da27fa195176532f6a890cf3dcfb5267c82b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a4d7a2abbf32cc7667352cd07bd44d9016bee51e045af2dfcfddc65f2a23b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c395b04fd22ec48ca86df97f322af10f487da514eb25a604a4b96c31e34d0203"
    sha256 cellar: :any,                 x86_64_linux:  "bbe602c73a9cbd28cf74cbfc256af18d65517ae1448049525420842af6907770"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    # "rules check" resolves which built-in review rule applies to a file.
    # It runs fully offline but expects to sit inside a git repo.
    system "git", "init", testpath
    (testpath/"main.go").write "package main\n"
    output = shell_output("#{bin}/ocr rules check main.go")
    assert_match "File: main.go", output
    assert_match "Pattern: **/*.go", output
    assert_match "Source: System built-in", output
  end
end
