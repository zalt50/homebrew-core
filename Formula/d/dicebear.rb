class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.4.tgz"
  sha256 "ab8e430f1b4fb999372cf78b274e04ca999fff16891f19ece63f63ab7f7aa373"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22e8bc01e12dddc25982aecfe7436c0c0ac53299191039060b2d1b2f440ac6a0"
    sha256 cellar: :any,                 arm64_sequoia: "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 arm64_sonoma:  "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 arm64_ventura: "6cd2e65e517ada31b350201063bab3ec51163447732ba73541e68158d565b1ae"
    sha256 cellar: :any,                 sonoma:        "bec6992b45e1ace0b2862d90c2764aaf21d270227e652d05620078e3ec8e4f9a"
    sha256 cellar: :any,                 ventura:       "bec6992b45e1ace0b2862d90c2764aaf21d270227e652d05620078e3ec8e4f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7828cf098c33bd975cad5f657ec7cdf4faad2c78cacf65293f0713fc42e198ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45af81803b2bf97e8d4f50f64ba27a817f88b9b5cad916fa22bbf9232a78dc38"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.0.0.tgz"
    sha256 "bbe606e43a53869933de6129c5158e9b67e43952bc769986bcd877070e85fd1c"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/dicebear/node_modules/@img/sharp-*"))
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/dicebear/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
