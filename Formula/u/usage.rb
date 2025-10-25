class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "57662c24177ff5eff676a9dc4b05ecd9b67fe22d5b185283ee7c1c5a10e9405a"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a9262b191f3ee7c479f436c93935283271aa2c9df2527f4bca36a53ad62aa75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0dd0e168b1576ed886991f240c37d2c7972c5ad3f1408e1e8bf3626a75b8f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef06ceb5d988ded937a4fef273a943131eafa1a528842f14bc949f75d9b8de2"
    sha256 cellar: :any_skip_relocation, sonoma:        "391f5ac67a22ce23827156180da1cfeda8b26922b7968abd78e239c3f946a8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3691a0b53378214107a0e93d338fe0901448b0d67db3f4ef04834b0dcf32a9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a006a5cc690b26595ee75ab9945adc3a45f2c52cb0401ea2dd724a93596f0f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
