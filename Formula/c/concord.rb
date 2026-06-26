class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "2249338feec07860abbe92275fbb58323a0bf5d11b29b8678ca9a6b464f7f40e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a6fde5fb1c4cd1318e971cf53f3db835460bd6767ba58d549455914990156d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4836f8d825a48b48a8c7413dccf6b53c19551adb5788f0ffc19ce08380681958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09ca343c5671bc068f4bc56c0925f36e58a54a6ff85dc9943f1a8e7d5850763"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c76ae9261285f76ecdcf6f6f3937bc35128b28c3b2a5006153ba34a7a8dcec6"
    sha256 cellar: :any,                 arm64_linux:   "484ab28fc4d5d6d7a02f89ebf7e0e7e01f46a66145e1fe6a2705dbc8f3a2e9a6"
    sha256 cellar: :any,                 x86_64_linux:  "c27daf71b7eaea34db9a4aa7889eefd18a2b90f1d1dd8d49de5b7bc26c1a2ea0"
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
