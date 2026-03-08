class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "https://gitlab.com/esr/wumpus/-/archive/1.11/wumpus-1.11.tar.bz2"
  sha256 "6b60884df963d785759ecde67382cacae2989f666be7b6269af511a51fde5458"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/wumpus.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e06701869c21c2e18ef131477db256df8f876160dcc67eb17d216546f658cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "418502a95f4ba4577d30f5e48699cb2c434b64cb63bc34bda4d28f8525d3b3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb4c854f4a9ca5952140e121567c502f46af0e6ced51b8916bc9fb3147b9a085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37eece81c8fdacbd791f7f8365364e2de6630c5ed93bbaffb9624c347b53f8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a59c6e421b3d461bfcfdd91b85fcba05a205df3eca4eaf0e0611f83e749f8fcb"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1866abf23ccf0920311248107cfacd4da35d2081903ade4bde1c7879c4f711"
    sha256 cellar: :any_skip_relocation, monterey:       "1ceb6248fd61580bb9c99ab1833503cad88c84daf4816771cfdc96f087755fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f9a87dd8a82fc0bf2969cedfca5dd336e0e3575d6792bf3d8e19e6f3506332"
  end

  depends_on "asciidoctor" => :build

  def install
    system "make", "all", "wumpus.6", "CFLAGS=#{ENV.cflags}"
    # Not using `make install` due to issues with Makefile
    # https://gitlab.com/esr/wumpus/-/issues/3
    bin.install "wumpus", "superhack"
    man6.install "wumpus.6"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end
