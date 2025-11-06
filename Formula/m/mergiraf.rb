class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.16.1.tar.gz"
  sha256 "168711e3f7bc7fd1df0e5d7154004060c9aa682ffae9092725c09e119a6da7b2"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ade306908441fd6f50a8171cef4c0f746825e85c7f802f3da06f7d34ce615e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac6651430b16832afcb4bb62bfbbdad81190f4f64fdae032e3b6fdd4d059e1c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df24ba0756567ccdfd695c1d0ecf805e1fba8ebfbe533875035e2fc509406a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "8636612a4bf42b5be0dff9ea412d57e548434ac63936f5b8848d01cc4ca8cf03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "381572b8911db273813375af7e93d620c8a206c7dbb27d5fc1652cdfde66b0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2f93bfcbdc41183d7e16d8d65bbeb1e6c6e2a807071adeaf623dff7ee85ebe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
