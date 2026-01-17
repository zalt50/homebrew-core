class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.0.22.tar.gz"
  sha256 "eb37820fd006a25a588463ace2e05ac550abaa5974bd7e74bf6612aad19f2d21"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "240ec668972a5a83df0ac37f542cc558cc36524540a50ed901f458b19fbc1c6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef6a6748671d597ad42e919a64efda975e3307fe8b73574f64f8ebc64edd1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df94b05a736f9b983554dd02e731e7fa36c9acda0f3f493183ec58826008666"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca743d4ba4082fb938512aa34092380e12662be2164db3a5af9d551a36fe44f8"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
