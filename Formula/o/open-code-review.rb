class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "e6a69f15e74c13b3ef455b2df4e51d69d88057f07ecf2d64f20d4a02673a1756"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90517c55cdfe7f7ee02ec5ee599499f0833dd59b51538f168ea00eda67553156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90517c55cdfe7f7ee02ec5ee599499f0833dd59b51538f168ea00eda67553156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90517c55cdfe7f7ee02ec5ee599499f0833dd59b51538f168ea00eda67553156"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fafa06abe040d1d55e6f7c1472d755730c3d7df1f5ef44ec3dd2ae94852ee41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64728e4ff561dd2a9bb4d90a00ddada79f53778007dd56dd29d56a8a4ef92a58"
    sha256 cellar: :any,                 x86_64_linux:  "0d28c9da4a1a9b64cd890910258fb30efd82e7eb82947f2fc929bfad3ad12803"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
    generate_completions_from_executable(bin/"ocr", shell_parameter_format: :cobra)
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
