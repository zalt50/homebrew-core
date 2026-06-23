class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "db105c96543559056ae8026ffa7754445883402aeb85fb62325b7072be4e911a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00e512f2014758eabd07b51718eb5b537eb42894b04c002397ae29e87506029b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ca7919dfc432c78ff823dce1dd680ad1e6dd1d77530b20f1a085090980997b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89daebc551525f7040f4e63daa7ef2c163839ff5c926bf9355417c4da69ad010"
    sha256 cellar: :any_skip_relocation, sonoma:        "59dc3a43d8b8b53645a1290f6f95c512ddf60c7645d41f4632b923b3bf8f7bb6"
    sha256 cellar: :any,                 arm64_linux:   "bca136ceb550163157a3d8f9239f134957c9be7629081cb891a402c5a72544af"
    sha256 cellar: :any,                 x86_64_linux:  "aa7ef20950a7b50f631d54daef0fb01984ce6a177bf01accfdcf01e7c3176c81"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
