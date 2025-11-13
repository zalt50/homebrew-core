class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.11.0.tgz"
  sha256 "d5d100b88c12f4fbc1bc0e68f152d06aa062b632b4e7d348bfde2b7294c1e756"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "07d9c4307429c57c9e760498886ce89eabcdcac397dc917bddffe5ec1ec31766"
    sha256                               arm64_sequoia: "1423de968f37d9c431ed9a080de32b709df41d69ff88b73036460b3a646e4f20"
    sha256                               arm64_sonoma:  "913db3100b7ca53111466e8bb12baf35393604c892ce18de17a411fa2e8d4238"
    sha256                               sonoma:        "af3badf70f7de6f309ce7eaa42c7aa2a62f6a1a089e133fc7521886a470579e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245a556b55cb1d9d47ebb2a8aa5e9b4893f403ac1fb380bea08fb44e46d5a6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a34f353d40793723a1fe3a4df642cbb157c74e7c03dcd393ab9b7712e2a1c0f"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.1.0.tgz"
    sha256 "492bca8e813411386e61e488f95b375262aa8f262e6e8b20d162e26bdf025f16"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
