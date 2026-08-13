class Awww < Formula
  desc "Answer to your Wayland Wallpaper Woes"
  homepage "https://codeberg.org/LGFae/awww"
  url "https://codeberg.org/LGFae/awww/archive/v0.12.1.tar.gz"
  sha256 "97b3f1c6d65d9d30e51b17092a45244f8c8549607c9207f3c98d82b28ba18fca"
  license "GPL-3.0-only"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "scdoc" => :build
  depends_on :linux
  depends_on "lz4"
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    system "cargo", "install", *std_cargo_args(path: "client")
    system "cargo", "install", *std_cargo_args(path: "daemon")

    system "doc/gen.sh"
    man1.install Dir["doc/generated/*.1"]

    bash_completion.install "completions/awww.bash" => "awww"
    fish_completion.install "completions/awww.fish"
    zsh_completion.install "completions/_awww"
    (share/"elvish/lib").install "completions/awww.elv"
  end

  test do
    assert_match "Make sure awww-daemon is running", shell_output("#{bin}/awww clear 2>&1", 1)
  end
end
