class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "f712acdb6071c7c83f6887fb4fab76e18986e499c2cf687088287c6d265f9530"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bec27ec1a681bc2f53f1858e01852c77aa0036e8f22a3d05e612563dcc99cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aade0b425f9b3e8b59f7b8481282f56fcd7abd338c116a4bc5960c14c7a4243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e54765dc98017fd7d332210b098a83b13549dc6c68cf8e12b5f0061da7bd9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "47fb04b4409bafa14bc8cd867644506cba1e79bf214f43f7295cdce845a29f70"
    sha256 cellar: :any,                 arm64_linux:   "52297ee84b710181db36ced9f1f9d573944f8ee890365b3f7a38818a848791fe"
    sha256 cellar: :any,                 x86_64_linux:  "3d587dd24a53e989a1094dd780b81e33ce5907d830886cb5719b7d7c7f215cda"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
