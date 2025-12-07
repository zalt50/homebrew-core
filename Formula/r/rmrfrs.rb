class Rmrfrs < Formula
  desc "Filesystem cleaning tool"
  homepage "https://github.com/trinhminhtriet/rmrfrs"
  url "https://github.com/trinhminhtriet/rmrfrs/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "50fb55c8dba436998de87725427ee336045a2ee67d7ef9430ce875fcf8826d51"
  license "MIT"
  head "https://github.com/trinhminhtriet/rmrfrs.git", branch: "master"

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "rmrfrs")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "init"
    system "cargo", "build"
    assert_path_exists testpath/"target"
    system bin/"rmrfrs", "--all", testpath
    refute_path_exists testpath/"target"
  end
end
