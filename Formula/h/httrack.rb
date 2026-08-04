class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.49.16/httrack-3.49.16.tar.gz"
  sha256 "36adb260e3f5a5a8e061b0375ac44be4d26f02b421a7dcad58033a776ec43d5d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "e53628c97424f9981e9dab3523519261e1804c8c0cc987b07d6d62e77bde6301"
    sha256 arm64_sequoia: "80b142030243938a29b26c20d12e5216ba56de4e042c971f712e0be5259f2514"
    sha256 arm64_sonoma:  "4c4c620c08c27b0bfcd0dacd7adb99a6f4d59cb1150e21456ec4aa0ae18da3a2"
    sha256 sonoma:        "560fc6421886adfd3897f51e6d376c547d340c7cefcfcb828cf2f8280d3e50cf"
    sha256 arm64_linux:   "0085d453abf9ba3252db544631e4bbbdcd4ceba2b83e46f0bb5a3609abf2df3e"
    sha256 x86_64_linux:  "24549365df25b87ccfec1c3fdf9b9310d102991e47ceb5b16d7c053a9d5adfc4"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end
