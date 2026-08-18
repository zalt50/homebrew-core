class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.2.0/bulk_extractor-2.2.0.tar.gz"
  sha256 "b9e15d40d711aa43590e1bf1a25d30943e3bad8371281d7c80d3803a6f34c268"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91e27eaece667b8f117802801bd09657b709013aa3a1a439f4c9a32d1643317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d913b32eda61a6ca752bb16bf19411549e5ce26a01fe925e8e96f3257d6be16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be54a1b33bbace334e2ccbf21090bb134353bed403033533fe0af2082ba368ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d50c440d9d084bff2d9aac53b3cb15fa60926177ae4c218a079b914fc4470e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1481485958ddd10ca9171c3e339a23ebe27877e57050cb440aa273f86e2845de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd01a677511ca96405ee937506dccf9ee51966b5658c0be0a24707fdeebaff5"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "abseil" => :build # only needed for `re2.pc`
  depends_on "pkgconf" => :build
  depends_on "re2"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4" # uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid overlinkage with abseil.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
    system "./bootstrap.sh" if build.head?
    # Disable RAR to avoid problematic UnRAR license
    system "./configure", *std_configure_args, "--disable-rar", "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "https://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system bin/"bulk_extractor", "-o", output_dir, input_file

    assert_match "https://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
