class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.0.1.tgz"
  sha256 "cb539b052323ee9bd7b147a63d9d3303b5bec9a00c0b7f0c4faff27291936e40"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "746b99ccd13c7e7e271dc8cb4d0fd806abd8ba89315b23b970b184305042bdf6"
    sha256                               arm64_sequoia: "7e479bef26b6f1ada59d1629024f7553989f29de53fa29793a602d2544822aa2"
    sha256                               arm64_sonoma:  "7c15370ad4e3634e7f629773f4d786c58fbae1990dc7222d15025818352016a7"
    sha256                               sonoma:        "cce0d9241ef66695946ac18f8d5a89c14b235ce7b3a11c38072c1e8f96e8731f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6abfe6c30fadcd89090b8d01a1b0ce36015083efe352a3a8567fdcaf99000a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd673e6b9deea9d83584e853aa314debaa87c95d4e34a485ce655e485e0098b"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

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
