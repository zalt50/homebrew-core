class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.11.0/pup_1.11.0_source.tar.gz"
  sha256 "26bcc6863f528272fec06fa0892537c1918d581d8b027c31c849f2c95ed7df27"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff8c74afd8a891e2b8b4378f20e50fb09059bb2c7c2579a64af224cae23f4db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b29f16f3da3d3cc5ea1237b4133ba7c6baec75de80c4c321f64fdbc62bbfcdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a3d77502cfbec9ce535ed73c9b7dab96d4bb8285c583112325239841738efd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32b3e68a759f4af25a380e1d2bb8cf29024b6be0edd305c3f26c6cab545620b"
    sha256 cellar: :any,                 arm64_linux:   "2b3fd1adc207daadc2ba63dafddc3a5ee19c2d69111a85f122502a6d4fe4a5c6"
    sha256 cellar: :any,                 x86_64_linux:  "f9b69404a690444decbdd920afe8dab49f79d650b1583d791e32e95d68d62d76"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
