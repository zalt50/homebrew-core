class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "6db487ff03f5e35937ba479636ee2f910455800fc5f876344bc3ada87aaca1d8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f979581b9f023d29714f2c3aeafd67030bc1dd1f8efcc7b88eb12db8d73dde6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f979581b9f023d29714f2c3aeafd67030bc1dd1f8efcc7b88eb12db8d73dde6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f979581b9f023d29714f2c3aeafd67030bc1dd1f8efcc7b88eb12db8d73dde6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff91200de287458e703570f7812871896ef4daa56328d0cabc61e31113248a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c33cb3694207eebdff95740933b5653c785fad86a559444c9795a8dd17aa85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09235d7780ed49ca253628ed73db526c5f072c3113216826ccf9a55ce6b5198c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
