class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "e760cea3985f4029501a4170bf33d6dd5d4ced6414ee9b38910efdb34e514cb8"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec4d391813a5aba36cf871e0af2074df82891a23d101adf0bec0d0abad37311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f0473762fb07bf92c5b8dc9701086da0c3dd057deac4f7453483f56aefce0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b935d55a785552a92ffb11476fd36c7dfc3c76ae19d97800eb8a003b6ec930"
    sha256 cellar: :any_skip_relocation, sonoma:        "df1538ccaff3c5df50f445649d9ed1ad875c99f629066117d2a9ac01d705b7aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14419f1805216ad46a52b91bdae6768bef51516df43af442ee601524cf25cd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8cd6125a0a74570e78be2da350c5da7a70df95cfa7b85ab122649466fd23b51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
