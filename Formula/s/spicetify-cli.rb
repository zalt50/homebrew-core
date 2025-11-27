class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.3/v2.42.3.tar.gz"
  sha256 "2d1108bff0b3b6232e34b417fc7ff00fa661a04afd23f4ed877f2514696ab197"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7730828c325f118c5b7cda8176325c5138255a906805d9cc040a75e87421ecc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7730828c325f118c5b7cda8176325c5138255a906805d9cc040a75e87421ecc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7730828c325f118c5b7cda8176325c5138255a906805d9cc040a75e87421ecc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e75f1614c7b8e1824f93e7c8ab527b2a0d1f6d00d7d2534f4469a488eab9737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "709848e4b1d8b662022cf5e130b6e1c8f839b677583db6a468c2768735fd72ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee33c6a04113305f92bdfb36486cda84d69bec9090022f2fb3bdbe4a23bb244a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end
