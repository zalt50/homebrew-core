class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "6c9556bdc74a78d6c2e50d7fd9949eaa2ba82b5f7f41ac178ca53bfc7247a651"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "060225624cb0fcedd7e96cbbf5347dbb51649f6485f2ac8934814bc9570d4b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1853292e531cfa4e74be3975f04875fc5dc074d65b6d638eca79576c85c79096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3275e8d066bbfd75c62033bd30001912f49c07968fa4d811b415340ddda5f0ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc241c56b2558ff7ed02e684e8dc3c8d2762f2483c39fb3018f1bbbec63d113"
    sha256 cellar: :any,                 arm64_linux:   "d5fd083b69ab076637a17c9777c34c1f30822fe5f6ccd4541e62eaeb3d4ad2da"
    sha256 cellar: :any,                 x86_64_linux:  "10ef978d91010e4bf857a2fe94f89f7e020193420c74592f84c118b5f1f9458c"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
