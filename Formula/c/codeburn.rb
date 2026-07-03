class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.15.tgz"
  sha256 "343b11c8e70fbeb2694d81000ca86d34168faf7a1452cb5478dafae09eecdb1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d85eb05ad9867bd0f7bd12d9c7d06996ec5f2799566e65710565eeacc5c85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc879ae8e634fb17d29fdd4967891f62e87888ffc9f7f62a004afd93385c361c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
