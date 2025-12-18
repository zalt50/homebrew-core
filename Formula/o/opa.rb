class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "cfbd4a603fc36bf8d609a876b27be22222e67457e2b04de371a7dddedf55d689"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16e9cb8d60489771d171971e27960b5d8211b37ee090670d88d0bd8a02ca5468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f3b9f9e95778360636406f8cfd719428f9d3ad5d8ae95a16dd9331c64e783ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c862a44d05497935f5478c1d10f83a2cf73ec330a59685fd3776160ada45fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3f07c6a6cdba047efece1f2c6f06cf23b0f1639e49dcddc54d7ef23e6b350e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ad0995bca598473402bf6baf2297579b2a996b69d1814589a28641d32470ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bd553dfa9e4135b4c751183289ca65107aeb27ac92cd004d8fcb44c4895b54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
