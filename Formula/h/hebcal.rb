class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "ab7e1f76b212b679ceeb0b1b74b30e98019691072ec69b57f927a4c1b911bb45"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48fda412107c2f4fd5ea5e546f4c51f434992f8f6b3723db337901fa2103d55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fda412107c2f4fd5ea5e546f4c51f434992f8f6b3723db337901fa2103d55d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fda412107c2f4fd5ea5e546f4c51f434992f8f6b3723db337901fa2103d55d"
    sha256 cellar: :any_skip_relocation, sonoma:        "24af06ed019e3d148da1d82b34321cc2e15b25b1015a2e6bbbf27f34b4eacb1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fe7fe66f53fef3159734d2a044ffb47179d0faba6e7c9061f680c0c1550557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014a4cce2e1d3fa440856b470c22cc5631ae066ec20bce27a474b26a2517e4d1"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
