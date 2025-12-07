class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://github.com/b1rger/carl"
  url "https://github.com/b1rger/carl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5356882e5efd1e3a06470d157f9a8e2a6ed76917dcbcfa20a1cae90c4c6d6510"
  license "MIT"
  head "https://github.com/b1rger/carl.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end
