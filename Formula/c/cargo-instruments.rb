class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "51b9bb614642e5de30a8757de8bad988d63e2064c7eb5fa5a9fadadc22f35c06"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c47ca1c2c976173e329bf560218cd720e3731e200a3d067bae40f962bae5f690"
    sha256 cellar: :any, arm64_sequoia: "2191dcb56c905954e1cced325db62b86284d517546920075b8fc90e9c935a609"
    sha256 cellar: :any, arm64_sonoma:  "799eacb7eaaaffde633bbfaa4174643fdf217ba292ac23a002dfe91e5eea58e2"
    sha256 cellar: :any, sonoma:        "bd06aebdb085962df308ae8b9173105f155bc496992002db1e72a87abd360e60"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-instruments instruments --template sys 2>&1", 1)
    assert_match "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory", output
  end
end
