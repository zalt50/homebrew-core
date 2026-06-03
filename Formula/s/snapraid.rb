class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.6/snapraid-14.6.tar.gz"
  sha256 "056f86b4f69265692d15d742ea7427804ef2e873aec4263425abb138be86fb08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d720e2398619bc01d7ae265596534ed9537bbaffdb45e84e1288b3f592609a29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc08e1dfd678172996edf3a75faad36e83eb6168853a697da3bfef41d23141e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a47eac29499fabd28be0c7ddf7c99416897d0fb098fb1257c8f54013b1f90d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd489414c2991497626a153aadf3dca3fe6a506e85a7652b0322bd004d1fc2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d753879ac339ebf877094e9eeddc3c12c96e9f0ac514da2936ab1fd6c015a84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f05efdfe1e63c7408959590556985dad1cc6293bd0ca0b0bc6b3c741e62fb30"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
