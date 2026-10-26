class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.13/xmlsec1-1.3.13.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.13.tar.gz"
  sha256 "7e500061eed734c55d74c786998e7562e55b1aaa72a2dff8ce3130b4c5b832d5"
  license "MIT"
  compatibility_version 5

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f71dee49e3175a7ee6f3da3451cf087491d95b8ed71b87701faa425b1ca21045"
    sha256 cellar: :any, arm64_tahoe:       "97494abca9775f6d866eaa4ffa98bee024f356c69a8f254d937fc8743fbf646e"
    sha256 cellar: :any, arm64_sequoia:     "d99674498676dfd3281708e1b142af8d09bef6a7c12ba02da6b68ea4a2979d0b"
    sha256 cellar: :any, arm64_linux:       "b6641f5d80eb48b4fe3f063855b1f5e8590cae9316661e4d1400344f8725bbf3"
    sha256 cellar: :any, x86_64_linux:      "00d72ab9ef93447eec2a23ec937f45eb6ed57fd49b0b38218f720031e66a1022"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libxml2"
  depends_on "openssl@4"
  uses_from_macos "libxslt"

  def install
    args = %W[
      --disable-apps-crypto-dl
      --disable-crypto-dl
      --disable-mscrypto
      --disable-mscng
      --without-nss
      --without-nspr
      --with-openssl=#{formula_opt_prefix("openssl@4")}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"xmlsec1", "--version"
    system bin/"xmlsec1-config", "--version"
  end
end
