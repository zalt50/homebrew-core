class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "8cf7b4ae540801171f4f630f1f2956913aaa87483b7ac03458f52b6cd0c48953"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed92cefd6df282057e6c1a162eb453d4c8d3b34a4a8637bf292813817badef81"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system bin/"create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
