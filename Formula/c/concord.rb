class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "1cc698e330986c82fda28875cf3ca1c8d0f5813265fc7b6a0713e31768137455"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1482b959b5bb0180c84dd2c8d0552ff0c2978c33bddd9a9f2074126d2bd772c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e82c061fe5cfc005fed9d851ba36af22f5f390aef73f2e1316cf0d613ea5137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b9526f13f2107b92c4b853c97a97db4e81e2f976de308f27761ad8a7ec41253"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea645dfe0c18953003b4a899e6fdf7de621a0528bb97490c83f9551504675fc"
    sha256 cellar: :any,                 arm64_linux:   "c3d69a8456fb48881ccc1cbd72402ae252e5cf747d4809352a8bcc72450fb8b5"
    sha256 cellar: :any,                 x86_64_linux:  "3eaa6fe1acba5a028ab26d645feb5f1894c3603e10655b6f182777ee1cad0826"
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
