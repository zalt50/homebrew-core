class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ee750d71f32861013cb758dcdb281490090682f1ce3fb70bc516b2b0ef82d7ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c1ea328fc65905ef83b1ba155f225825414654184183d8896b9e4e2e565073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c1ea328fc65905ef83b1ba155f225825414654184183d8896b9e4e2e565073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c1ea328fc65905ef83b1ba155f225825414654184183d8896b9e4e2e565073"
    sha256 cellar: :any_skip_relocation, sonoma:        "1897a43bb8bb93e1699831e6c5b8a4c491e15b0a65bcbb9b57e6759c1324bfae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59768599931541350b9473fe6653674359cd336789c552acaccae0ad73291a8f"
    sha256 cellar: :any,                 x86_64_linux:  "b0c4d629e252cad4c3f7fb30c21d9ac2feca9babbf363dd5548ec062e50c04c0"
  end

  depends_on "go" => :build

  depends_on "tmux"

  def install
    system "go", "build", *std_go_args, "./cmd/lazy-tmux"
  end

  test do
    config = testpath/"lazy-tmux.toml"
    ENV["LAZY_TMUX_CONFIG"] = config
    system bin/"lazy-tmux", "config", "gen"
    assert_match "# config source: #{config}\n", shell_output("#{bin}/lazy-tmux config show")
  end
end
