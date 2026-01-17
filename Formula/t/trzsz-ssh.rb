class TrzszSsh < Formula
  desc "Alternative ssh client with additional features to meet your needs"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "8c7ef4ace4c7aed564f447f3f91142367f782eef87b58a95f587480ca1ae08ba"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49a6e4f5145e57aeafbec67bf1f200393b64e931af6906e1c940bade7941f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52121142aa23b88a5f98b2c2980a428bc00c837bc46dfa14829f90798cc44b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3502362a3dc731febbb45ff0cd6b1b1228424fc7dbad0307695b237ad1f0358"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tssh -v")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 11)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 11)
    assert_match "invalid forwarding specification", shell_output("#{bin}/tssh -L 123 2>&1", 11)
  end
end
