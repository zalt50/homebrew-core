class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.12.0.tar.gz"
  sha256 "5ec6b7f20783c56bba15fdfbbae4210aeecf1f413d921cc4a393fac34eb0491d"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0a69db0056b2c0650e8f09070bbb3d2385b62e57a0a6c94db8c05a2616d66d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4637334b260559613baf1ccc974aa016bee299a27fa143f6e639d3ad481f6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c72091e200ed04ebc8f9b6d84507662a0e9691c893ec68697ed3f1a36347002b"
    sha256 cellar: :any_skip_relocation, sonoma:        "84db739cc2ceca5acf038cfe878366e4bb2d1f68201e4a2bc87238e66dfa5c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70b0589b12bc8c1c1adc4dc99182174de869503fcc1d88631b5d1f879c60b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8434529fb60b17ac966fefbf288b03f792ac0a3e687719b5f012b8a11e3d08f1"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
