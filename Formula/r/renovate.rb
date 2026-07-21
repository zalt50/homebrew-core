class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-43.274.0.tgz"
  sha256 "3e40555ae144324c09c0140b87aa15585e174aae82a2c1fd6ebfe383fb11f85d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e61b1e20f42e68172b89e8bf4003e300272b9a5adf63eb667a4945a1c0d4a290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61b1e20f42e68172b89e8bf4003e300272b9a5adf63eb667a4945a1c0d4a290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e61b1e20f42e68172b89e8bf4003e300272b9a5adf63eb667a4945a1c0d4a290"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61b1e20f42e68172b89e8bf4003e300272b9a5adf63eb667a4945a1c0d4a290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9135c0f020bf9a9871fb705361d787496ef2bd34f44d2b845a7898ade458e244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9135c0f020bf9a9871fb705361d787496ef2bd34f44d2b845a7898ade458e244"
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
