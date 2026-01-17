class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/refs/tags/4.4.6.tar.gz"
  sha256 "7765b241b0072f8ab963956f06f71ca18b743704d8200955be24a4b507978982"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14891cea79eaaec8482f370961e6950b16ceed386c7f26567cb5c1f37f42434c"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end
