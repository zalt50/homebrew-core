class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "1c0ec34a4eeedc0fce54c4982cbd0a871bd7e837f3e4567537188cb0de7bfe62"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b9e4088b638bb1c34e712bb2db70fe2c59b9d2517c6b1b7a0c643b131dddc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5844e78b71515b20cfc660f35878d8ebabf978850c15b5f0e34740c3619e29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78b816996ac45c1ff440466e08bac06311350f99070635093b300fb8621274f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d444b545096d115b17af5e27530676e0486f08af7bf00e03019f3a515baa0ff"
    sha256 cellar: :any,                 arm64_linux:   "e4dd0efff741c8bceffa9c2b294c0a9a5d4e7ced691ef21c87ae2d21cb57c99b"
    sha256 cellar: :any,                 x86_64_linux:  "9470ae6ac1ebd433cf47e7d4285d7f2d368e7fb4f4750daaeaf113d4707ec408"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
