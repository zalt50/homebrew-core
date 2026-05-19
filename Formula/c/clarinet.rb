class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.18.1.tar.gz"
  sha256 "21dd97c32c96c9884722a1025739b24b68526bbcf138c3bd6cf7cf46b2b2ff4c"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a7d5a4390aa9b92979322411c5373eeb3d5eab510c34cb2f7cfa6aafc6d170d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48945139d4082d11e703c00bc57204e35ceca72b0f33cee3cd84e1edbc984e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5ebb23af0e5f8335e4e4438b9dd799d340d621f64125f60583b5c115cc2e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b84de76b19a0e07787bebff915809e68b5e6efdfd992d156b41104009d0980f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d4fc8fab7892c9a05c622f8f24b4da34708fc5f3c8bf11cbcda6eb6aa36bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85a0d1341c0bcd8713bfbb098fbf4f5b465f48a429e7f7eb24485915fb29e28"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
