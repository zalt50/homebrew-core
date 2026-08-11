class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.2.tar.gz"
  sha256 "f548e09d13f8bbaab9f65d552699c939c2d2674d8f119f857bcfb61e52f6f266"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf02d9e2688dee8b0c3b1cea59d14819981aea0897dc97e6c7802dcfc4881b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6362c28613343efec60dab15323b994a0ee4980aad4e2abc296305e0cd3ff161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a405bf145fef48bbd55a97281696c0a19bf4116207cc3992f6d6bc7d87a53301"
    sha256 cellar: :any_skip_relocation, sonoma:        "8634fb94be5c0096d1c6cc5b71231dbce3bc55e3170ba27f09843e63540b9850"
    sha256 cellar: :any,                 arm64_linux:   "1106fbfeba96bf46f27b17a331126720425d0825e8c28ea9e7db39476c2a4eaa"
    sha256 cellar: :any,                 x86_64_linux:  "947b1b1591baecbfb43a8c9eacc37d489edffab3b8c6174f1404cfe0c4cb5314"
  end

  deprecate! date: "2026-08-11", because: "changed its license to FSL-1.1-MIT in 2.58.3"
  disable! date: "2026-11-11", because: "changed its license to FSL-1.1-MIT in 2.58.3"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "swift" => :build, since: :sonoma
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
