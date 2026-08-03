class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "210db22441d86d3f10a13cd4d5dc5c581db92eb7c4a09576f04eaeff5bd84a7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d1ffd1dc403af1392eab7782d71fae43317f1dc6b9892faa9e00f76ca6fa47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d856bac0d07ea5bacd21aeba0a3d4b6b5b2bc00c3d2482d5ff91c59903bab43e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaee6b99417be0a542cc1da10e2c1886b3ab315acf5064a9da957e0bac2e728c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d02433150da16403ba80df0f148f329d78f475c76b6bddad001cd9069388f4ba"
    sha256 cellar: :any,                 arm64_linux:   "ffacf80b1b2b977f0d0a0c115d675f8f7bc4a34f3addc0c933bcce0e2d413af5"
    sha256 cellar: :any,                 x86_64_linux:  "3c93eb715a66c2eb2cb7fa1529531830d066d7c989a434e041f790704fab7fc7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
