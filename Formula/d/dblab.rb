class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "d31ef27cf5e653665ecfdcad39f30cc7116575e90227dba9856404e0b73ecf8e"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93952e4fea2de8ece9a75bd4925e9e0a8c8925c851d82e44a7dfd32b5a55f30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14b1cc24526bb292d95d8f1bc68d6eb2071fcbe60386eadbcc43f2fd6d27f5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60921f3d37768ab9ecaf13d1bfa037f3888badb8b7db11f8af58bdaa50e29e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e48480d90cc5de0b787878af40764dd91e1a00235b9e1eda37c71476c7ba9e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bae40cfaf93875ae7cd4bdfccfb23c96d68115d3ea43c24f9d08e36d8beb3a5"
    sha256 cellar: :any,                 x86_64_linux:  "8d67853251b92c8f40603602118945d14d066c85677245ced5a4623da2ca6b54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
