class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.2.tar.gz"
  sha256 "0e5b29e698fa8bf35600e2effb275b67f1a5e635d33a41e7f76aa63de6646ea0"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "f50f78aa9ad049afbe2a69c36644d4a8a743ae209a804275053bb0c7c159aed7"
    sha256                               arm64_sequoia: "0d313b44ae5a4b40ed5c27ba8c1c11225191f276f3e9cf259625029f05516d8d"
    sha256                               arm64_sonoma:  "47c7786d0d6d773b084d32a4e3d6c6db066f70f3d997474842d940d73112cf5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0ef15115c7b3f37a95e37fc12f4377f970b6c2401362272b8c0e9a167f39c0"
    sha256                               arm64_linux:   "b38a0c3587500d5e7e9b6a588d8086da1305ef8368caff84b8284090ca14fedb"
    sha256                               x86_64_linux:  "12afbec17550f280509ca70fa65e8a1d3e6526882c36474da972164833f39146"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.2.tar.gz"
    sha256 "29ed02b7054d781898f786aa9cb4ce1b509921704ee40b86b33352f7dca3b5cb"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
