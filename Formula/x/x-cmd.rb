class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "5f6a0214dc42790e7ac21ed58ca928e74b1682713b791b86a64edb656402b34c"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adea7e7933b0896793fbb068f6e48995d8f405c2ac60e0fd5521089902670247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adea7e7933b0896793fbb068f6e48995d8f405c2ac60e0fd5521089902670247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adea7e7933b0896793fbb068f6e48995d8f405c2ac60e0fd5521089902670247"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff7c46cc57ba01fd49627d73a96d2cb89860b2e01d31ed394acf18acc525b7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97a187c542d247a92328963550d7f683715e51f3ce459ddcbd827f6307fb151d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a187c542d247a92328963550d7f683715e51f3ce459ddcbd827f6307fb151d"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
