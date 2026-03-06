class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e1d70b683cbf8d1be505e818d91ef07c6938c82affc914eaf88f25d4f81edd56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616cb5899c24239ac26f4765d24a58e7ea972b0ef475ae564dfe4e03fb70dcda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b3b2cb3da19c4d5f505d08f73e0b35644833559a0b3af555b7b3bd416083972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c6df1b8ee469c45b63989d6d0c3f81a15426c3c93c6e83730b6ad5128dd37a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0efc7fab0c6d5a602d723f9285b8adad5806708c4da705067bc055f9b8488c7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef558f5abd25fb635a851dc36cced9c6ece1d1ba81456d119ccf3b7c9c94ea79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914baaac89170aff43746e5e99c36df336944c25981268e40933148ec7467ce9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/pk.1"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
