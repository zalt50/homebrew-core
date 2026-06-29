class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.13.1.tar.gz"
  sha256 "4913dd634f93a1918c30a75aa2c07e4487f9c53e306a720a08df4208dc8abd4c"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4889e30ba65d0d7573b4477d90c19723e56a8ea66e9467db31b7e998093fa507"
    sha256 cellar: :any,                 arm64_sequoia: "41ed161108a604415f4782ce433533e754010a2fb590aab88ac611510151143e"
    sha256 cellar: :any,                 arm64_sonoma:  "64bd227bec9819a11171b77e8600e5e88e08beca082bc23da1fe0ed2048d06e8"
    sha256 cellar: :any,                 sonoma:        "8e369dc7bb807fbe1430a0e2986c6068e88b3e2269cc1db64ebb297f3e308f16"
    sha256 cellar: :any,                 arm64_linux:   "2c4ec04032b6ceb904514b61a5788fa84ad02a1d2f1e79f2cc32cd100456971c"
    sha256 cellar: :any,                 x86_64_linux:  "20d50831842f8b4cbf8a58ad3af1b527891abe02181a964468c7a3f8b64623f9"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+
  uses_from_macos "curl"

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xlinker", "-L#{formula_opt_lib("curl")}"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
