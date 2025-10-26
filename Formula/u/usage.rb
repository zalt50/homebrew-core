class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "5bcc711ab2e6d3914888dfc7b07ae16bb796e83e7e0fc874804dd01f70f8e76d"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7647703cfaae159361e00005d2b4f560a33822aa58663409e75c9abcf80b62b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a8dd31ff5e62e0d37e645016e2ed6af8a7daaa03b451a57898fba2c777a67d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d262faed157c1ef8bc2a4862770a30a0889fd9ac420e71e294b13e8c81920c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "608684fe0c13071a5343921d3689e4f3467cbcce4d0f936403e4bc9c62a7e4fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb489d829cbb86c4ad8e75d88cb1d961d06f9e642baa58e5c8fb7ef0cbc6c275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ecef288b31572339c32247c0bcfe4f8d0efd277b4ca3dc5ef8b20ab5ba2dc89"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
