class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://lrr.tvc-16.science"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.81.tar.gz"
  sha256 "d4ded2cde7d30b5d565da8a0f85014a245cefe9a8f969a45aa0eec57854beadc"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a08186e57b5859320e33adb25ac611c7e47532a949f4a75f432c664eb7426c4"
    sha256 cellar: :any, arm64_sequoia: "c345ca33881da5849b2b85f8cc61d8953cc99bf5b03a163fbcd58e8df5695264"
    sha256 cellar: :any, arm64_sonoma:  "a7444bb5759009f532b43de12c77101946cf3501421fce0d67df4a971ad4562d"
    sha256 cellar: :any, sonoma:        "e02eb6b2c8e81781cf0df99134104658ff7fec1daf47403a173cd22efaf527d9"
    sha256 cellar: :any, arm64_linux:   "7522f7e5fce9e74a847e814dc4fd442c3fa64d98fc3ec631bf39df0477acc016"
    sha256 cellar: :any, x86_64_linux:  "28cffb909e2fd739e716c51b4710fef097be8fe078d188dc479782a52cb7f551"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build

  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libffi" # TODO: uses_from_macos when node supports it
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl" # perl >= 5.36.0
  depends_on "redis" # TODO: migrate to `valkey`
  depends_on "zstd"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.2-3.tar.gz"
    sha256 "dc6ee21aed560d36f36be608909344bd2e25d63ab5d959553401e02f5df28a6b"

    livecheck do
      url :url
      regex(/href=.*?Image-Magick[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)\.t/i)
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@3")
    ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"] = formula_opt_lib("libarchive")/shared_library("libarchive")
    ENV["ALIEN_INSTALL_TYPE"] = "system"

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL",
                "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *std_npm_args(prefix: false)
    system "perl", "./tools/install.pl", "install-full"

    # Modify Archive::Libarchive to help find brew `libarchive`. Although environment
    # variables like `ARCHIVE_LIBARCHIVE_LIB_DLL` and `FFI_CHECKLIB_PATH` exist,
    # it is difficult to guarantee every way of running (like `npm start`) uses them.
    inreplace libexec/"lib/perl5/Archive/Libarchive/Lib.pm",
              "$ENV{ARCHIVE_LIBARCHIVE_LIB_DLL}",
              "'#{ENV["ARCHIVE_LIBARCHIVE_LIB_DLL"]}'"

    (libexec/"lib").install Dir["lib/*"]
    (libexec/"tools").install "tools/openapi.yaml"
    libexec.install "script", "package.json", "public", "locales", "templates", "tests", "lrr.conf"
    libexec.install "tools/build/homebrew/redis.conf"
    bin.install "tools/build/homebrew/lanraragi"
  end

  test do
    # Make sure lanraragi writes files to a path allowed by the sandbox
    ENV["LRR_LOG_DIRECTORY"] = ENV["LRR_TEMP_DIRECTORY"] = testpath
    %w[server.pid shinobu.pid minion.pid].each { |file| touch file }

    # Set PERL5LIB as we're not calling the launcher script
    ENV["PERL5LIB"] = libexec/"lib/perl5"

    # This can't have its _user-facing_ functionality tested in the `brew test`
    # environment because it needs Redis. It fails spectacularly tho with some
    # table flip emoji. So let's use those to confirm _some_ functionality.
    output = <<~EOS
      ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!!!!!
      (╯・_>・）╯︵ ┻━┻
      It appears your Redis database is currently not running.
      The program will cease functioning now.
    EOS
    # Execute through npm to avoid starting a redis-server
    return_value = OS.mac? ? 61 : 111
    assert_match output, shell_output("npm start --prefix #{libexec}", return_value)
  end
end
