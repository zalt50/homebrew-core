class Ragel < Formula
  desc "State machine compiler"
  homepage "https://www.colm.net/open-source/ragel/"
  url "https://www.colm.net/files/ragel/ragel-6.11.tar.gz"
  sha256 "47653e376554adbb617d2f1da15394b6a163264e2410c2bff3581347a14890e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/Stable.*?href=.*?ragel[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a861e1645f5b8f830a41c21217ff8423360dcc678bd5f25648f3737e75e3f0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2bbe81eb822afe87192cd8b4688fe5bb9f84b2fe87ea343ef0155ff8b6590ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ee07f4d272aeaa30c28763be68741670e7e38c518e49fc9c214db1cdfa717d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a023336bcea614167bc5f77ed303c53e2d26319057c835f0d49c841895515a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4427818a8647c06fe09fffa1960f6fbf4ce2c10dee048b1880486390c151585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "858ef57e50114e0406d7afc3beb7c06462bc1b5ce2155948af84af0c41d739f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5771ddc6f4f2930842f90d27dd598a70fe35a0b8d0961dd67cf96fa5f1280f42"
    sha256 cellar: :any_skip_relocation, ventura:        "389f08b69edbc2fd8d9f79351549d31d2509e660c595c94e8e170432a4ba3d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe77eea34f4c9d9cc26f94706f55a3b38a595c9fb334fc0d3c168ea7abbf5b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "712245a75110f6628e7c07130d2905577f1a533bf760692e0f4b3071df20cc40"
    sha256 cellar: :any_skip_relocation, catalina:       "a402204e97c35c6a9487d2b0707e27766d9b39c9c2116d49e9c561e1d0bd54b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1273e5876162710bb47f6c16ec99b755035cb171d3b5d32be4e362ae7a3d08e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2306dd1c44d304bc0e86093e9f87e0e885d0d9ce03579ab55d7a6c9bf2ada95b"
  end

  resource "pdf" do
    url "https://www.colm.net/files/ragel/ragel-guide-6.11.pdf"
    sha256 "ea4850e48779b14f662c94d9d7bbf634b0860d2317c6996135b5b1cab2c5ded9"

    livecheck do
      formula :parent
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    doc.install resource("pdf")
  end

  test do
    testfile = testpath/"rubytest.rl"
    testfile.write <<~RL
      %%{
        machine homebrew_test;
        main := ( 'h' @ { puts "homebrew" }
                | 't' @ { puts "test" }
                )*;
      }%%
        data = 'ht'
        %% write data;
        %% write init;
        %% write exec;
    RL
    system bin/"ragel", "-Rs", testfile
  end
end
