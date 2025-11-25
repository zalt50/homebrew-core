class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/0.11.11.tar.gz"
  sha256 "7839a2767591260b8d56e236ad6aa7fe2a166e1bbdfaeee39c60c628ed4175c4"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a1613eb33c708f8ae63ca5a2fc98319b3d26380fb59681ad280d0debc6dc93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a1613eb33c708f8ae63ca5a2fc98319b3d26380fb59681ad280d0debc6dc93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a1613eb33c708f8ae63ca5a2fc98319b3d26380fb59681ad280d0debc6dc93"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f972d5e4546ce81b54db0762b69e04b919d26b0abc497746d3c411bf12c1256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37d974cc84dab2bba14d8c10fd84c007e0140b3539e5b91bc139ba52e3882ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6f95bd36ed7207e6b5ed542bb2aca21a3a42e75fb4b8b2ba0987c63e0be4bad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
