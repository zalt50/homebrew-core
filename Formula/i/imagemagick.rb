class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.2-12.tar.xz"
  sha256 "e22c5dc6cd3f8e708a2809483fd10f8e37438ef7831ec8d3a07951ccd70eceba"
  license "ImageMagick"
  revision 2
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "70a4007af2df1cbceee0f1d245b9c3b63610c7e47ea17bafb6722964b401c8b3"
    sha256 arm64_sequoia: "aa09d81bf684995f2b039a6fea27b58c5fa68d69af3b1111bc4f659a691e55ba"
    sha256 arm64_sonoma:  "3a6ab91642e7cd983422eddfc2535c56365dad208e4ecc10b2162fab2029e55d"
    sha256 sonoma:        "126ce8dfc0ac26bcc92193f6c27d49a9d79a9fa652cf56bb37107f2789736940"
    sha256 arm64_linux:   "0e44e1adc76f7985b20ef49cbeb1a96128b748fc27c2c8d52b3b2e192744c38d"
    sha256 x86_64_linux:  "97bf08e3d0a9dc3adaed58d3b6142bee0542de0add7c7882ccebf28f783a8949"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core,
  # recursive dependencies or INCREDIBLY widely used and light formats in the
  # current year (2026).
  # Add other dependencies to imagemagick-full formula or consider making
  # formulae dependent on imagemagick-full.
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "imath"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = [
      "--enable-osx-universal-binary=no",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-gvc=no",
      "--with-modules",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-raw=no",
      "--without-gslib",
      "--with-lqr",
      "--without-djvu",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--without-jxl",
      "--without-openexr",
    ]
    if OS.mac?
      args += [
        "--without-x",
      ]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      imagemagick-full includes additional tools and libraries that are not included in the regular imagemagick formula.
    EOS
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")

    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/magick -version")
    %w[Modules heic jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
