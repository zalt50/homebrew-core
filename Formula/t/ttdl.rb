class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.24.1.tar.gz"
  sha256 "f396b384ba3cc77882ec27e88af55e15da9685838485627fcbbda7b106160294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cc35f58e9f612e1141097a9aee937677a610c00ec0202f84506a8ac9a164958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9ecd0a17bbd5e32505b9a8b46114dd62a8d23369f6016cf13465e3eb8bd85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136a89bafc02210aa392284f9a4dd53ddd1dd070351202e52638b4040e275c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "18837af4ac3e24fdd150385acf8cacc3c09bc9659942444050ff6add5804edbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368ed44f1b3d701f74a0e0670acf310cc2ca3b9dcb373d8ccab2735808adbb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4798b0692862883287cf77ca945d0dfecdba8aaec8ee59ca5466efe9ca2ff2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
