class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "42551a9a53d4c88a3be495c30e4075b31f02ddc4d302afdbba3d8dfc3083b690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d1415dee606ba56a170689c6a38387aa795ca07c0b0608f8b448f5157bc406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1ac7595cd62454f87be931c4f90e864eb5c76cfee6df65c60d0ddb41aa3522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53061836ad80b8186be6eb3a00d69611d5ba14c13cbaf68fd47bcff4225ce49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "421e23b6865edebb668cca9d543d7e842f391d87d26b54c89346985caf15847a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97d799302693ff19597c4195a132b0d8dc2c6ab7ef568e067bb922600ed5af3"
    sha256 cellar: :any_skip_relocation, ventura:       "573f2eb8bed047e8375a41efbf1b1add345f99129aeed7d31c3369ce8829a780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fcb8484a3d6a6a66f87e30ae58effbe6b7b503464a68a73f0096cf27fc7cfb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bdb622ae30e6a2e7e9b1a5e082c282c978ccd2fc2304e9234bf803f23f6bd1"
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
