class InstallNothing < Formula
  desc "Simulates installing things but doesn't actually install anything"
  homepage "https://github.com/buyukakyuz/install-nothing"
  url "https://github.com/buyukakyuz/install-nothing/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "40c36b13d3eb9516cf74370428971d94400d420885d578208a7fa611785ffd01"
  license "MIT"
  head "https://github.com/buyukakyuz/install-nothing.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # install-nothing is a TUI application
    assert_match version.to_s, shell_output("#{bin}/install-nothing --version")
  end
end
