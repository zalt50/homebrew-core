class Asimov < Formula
  desc "Automatically exclude development dependencies from Time Machine backups"
  homepage "https://github.com/AsimovMac/asimov"
  url "https://github.com/AsimovMac/asimov/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1bd90fbf33d5e72bf578be3959c3a9e3cfb36951e364572d5f9f607889da86db"
  license "MIT"
  head "https://github.com/AsimovMac/asimov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "844e1015e05c3a47a7f7dcd1a9255369c0854c1c0416fdeef44eb99e0f507834"
  end

  def install
    bin.install "bin/asimov"
    libexec.install "lib/asimov"
    pkgshare.install Dir["data/*"]
  end

  # Asimov will run in the background on a daily basis
  service do
    run opt_bin/"asimov"
    run_type :interval
    interval 86400 # 24 hours = 60 * 60 * 24
  end

  test do
    assert_match "No new directories to exclude", shell_output(bin/"asimov")
  end
end
