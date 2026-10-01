class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.129.0.tgz"
  sha256 "dd20b668b35f08a040fa6b878c3f7027b189dbb0b667ebe7cd08198faba7508c"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cec0316238afd9f11acd12a6e2aaebd3f0a3c4e261f2181f687bd9dc4967fd8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cec0316238afd9f11acd12a6e2aaebd3f0a3c4e261f2181f687bd9dc4967fd8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cec0316238afd9f11acd12a6e2aaebd3f0a3c4e261f2181f687bd9dc4967fd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52c2ffc5c87ad369c3f60e0fda25e63f8e9a835c305c127e5d51b1191ecf8022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "52c2ffc5c87ad369c3f60e0fda25e63f8e9a835c305c127e5d51b1191ecf8022"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
