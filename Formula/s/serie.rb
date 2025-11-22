class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "bc7dd9317fc3b78097ec8305d0fc7a45170a6d7a2e3d9d8ffdeae49715acdbf2"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e7677022ade5c1e2ddbcb1b56928887e7a8d464fc3d6e88fba83350c2f7ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8409c00dd2c69a3bdd1d9d927246d3dc4ee52c56f9b69c705f28d87ee8f68e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480461ce2b61c16007fd91266dd27295c6d5690bcfa6331a7bebc1610ea32cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "da6c613db7b4b5e6f4ea09c6895976b0a3641d455832127247419a17113b272d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6252371c9f60c1590dd53453e750afec5231f467e91d6588e208ef53b56669f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b9c5771baf209cab08266ab5457ee443f07555330b555a3934f2f1e4a0447"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
