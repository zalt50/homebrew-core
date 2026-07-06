class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6216dd018ca749c355531fa58d52fcf7116db002022b890b09d8991285654ff1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c24cda7fc7141bb887efafdb0ed6efd827c282122ed760bf9f5f9f096bb08c18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4685ded9836d7130e3f6637f42cac0df53c135c8df3503739c6242d165a1eaec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ef895b290200af9f95faf06bb477c7e55051f2a194250b3d1e8f5c58b44f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3f4f94bb0f939a945e7597737a501be299061acb0e1f08370411b48010ebfe"
    sha256 cellar: :any,                 arm64_linux:   "ee3d17b942487da31b3d056d30faf802b1f465c6c6ccc5ffbefc3c88ec20bda4"
    sha256 cellar: :any,                 x86_64_linux:  "6816ed1e6e96de5518cfc8de0f9c972bcdab6ea76c6aa2c6b4a9ed73ad0a9e86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    (testpath/"concord").mkpath

    (testpath/"concord/config.toml").write <<~TOML
      [display]
      show_avatars = false

      [voice]
      self_mute = true
    TOML

    (testpath/"concord/keymap.toml").write <<~TOML
      [keymap]
      leader = "space"
      StartComposer = "i"
    TOML

    assert_match "concord config OK", shell_output("#{bin}/concord --check-config")
  end
end
