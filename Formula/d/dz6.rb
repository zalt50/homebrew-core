class Dz6 < Formula
  desc "Fast Vim-inspired TUI hex editor"
  homepage "https://dz6.dev.br"
  url "https://github.com/mentebinaria/dz6/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "be984784453a0964ff87d3987e488e1aa5a95bf7938ecec28fd5a3a670293f00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "827842d7edbe838bcef4216c404a7fa407aca18714f3f169b266d75555cf812f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74f7a02638b73224bb5c3774039c688715f1d29e9be94ea4d690764cba49827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db05c1e280a48aaab7a32d509a5401f97f110c314c8cee321c4d4894f470a959"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79f0617d6d80d560ed2602d193b6ec792c7aeb72652e6633da56edd9e28f4ea"
    sha256 cellar: :any,                 arm64_linux:   "b40dfe29315797bdca04d439cd9feab90d1b829acb4463084380b337e4adcaf6"
    sha256 cellar: :any,                 x86_64_linux:  "e50ab6925db3259a807fb8b5d6750001de6f0911f01bda4d61b01aa159e8eb24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dz6 --version")
    output = shell_output("#{bin}/dz6 #{testpath/"missing.bin"} 2>&1", 1)
    assert_match "No such file or directory", output
  end
end
