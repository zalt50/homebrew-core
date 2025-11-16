class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "7f2964b474ac3d2d41b5a9bf5a18cd3ee369b2c1cd7aa405299b385ff20ea5db"
  license "MIT"
  head "https://github.com/benhoyt/goawk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e167acbe38b7220265c989491b3b4a6c146b5320bdf8a739187bc00e6ff3c35c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e167acbe38b7220265c989491b3b4a6c146b5320bdf8a739187bc00e6ff3c35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e167acbe38b7220265c989491b3b4a6c146b5320bdf8a739187bc00e6ff3c35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac7986a9c164174f062c7faed31cef6efbdcd5cc45d50ac8ebd3da037c164144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367d08fd04359f03dc21f50c7974e4aa705c0c6ba48feeb0588bf3f209b2d2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5760737d1b8b8ce1424ee3ab0f3688d5dff9a5b6d251a3bd923148b1e912af12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
