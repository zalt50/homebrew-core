class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v5.0.2",
      revision: "9ba2cf5c435251c8459e55d7228c4ef896ed0e4f"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0efd112f24f3de3a298713288c2718341f1251e157caad937a98f73bfa85685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "482815a1137f0aa77c81c097d612ff6f3307ea84dd82735e5ac02aebf1023b8e"
    sha256 cellar: :any,                 arm64_sonoma:  "f5587da348f094aaa2be97ce0893c4531cae1c4e6e1a1e2bacd8d92ab836b67d"
    sha256 cellar: :any,                 sonoma:        "fab3b6f671726181bd30600c479e7736496e7271cddd0eaef3dd3eaabcfca0df"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_sonoma :or_older do
    depends_on "swift" => :build
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
