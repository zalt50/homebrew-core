class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.49.12/httrack-3.49.12.tar.gz"
  sha256 "2f4362802e2b42a0f6caf5db37a53decf962e2dc876ef2c2507d1a53db270bc4"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "b32f52b8a3d7c29bc4ef8786a5d7442b989d007c92ed205bd8e2fce3d7d9e7c3"
    sha256 arm64_sequoia: "c490f41b189c3f0627d2430c16657c2789ef61fe533d90ed72ab5c5e0869fd9e"
    sha256 arm64_sonoma:  "896935f765df6afd7676c0b3e582ae66ce4052a097b20e78200aadef15be4268"
    sha256 sonoma:        "58af4297d8cdebb0c20de947610b3f473f5081ac81fbd75a253c27c570362c2c"
    sha256 arm64_linux:   "548edf68271f1856edf0f9c34153043ece5575d8b97f1e3373cbabde82f93cff"
    sha256 x86_64_linux:  "4425d23c7e0fc3fbae36a0201b1519e4fb2ad3f6789caa4cf1b58b43e8c826cc"
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
