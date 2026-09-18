class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.9.tar.gz"
  sha256 "d98d9a883f896452a7131268a6c20cbfacaf8a7ae980184b5bf4d0f7923d9be1"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "ead2a6d33de95e898faf788f55ef193391bf5567c39e541e17c608c544921bfa"
    sha256 arm64_tahoe:       "5f220af170197961911624a9d7e176266a8df159c289e34dd6b88fa3480b16f3"
    sha256 arm64_sequoia:     "7670eb90468d48a6706a8ecfc278d9f57651fa078070a7f970f098559b279574"
    sha256 arm64_linux:       "92f631697546dbb661cd4e1785511eb7245ee9c785dfbacb7447601471dba8da"
    sha256 x86_64_linux:      "b0ba5d91e42de65f3f4472b801e2c4bbc5e970a9ec611c9614bd110473735764"
  end

  depends_on "gradle"
  # TODO: Switch back to `openjdk` together with `gradle`, which runs on `openjdk@25`
  # until Gradle supports JDK 27; mixing both in one dependency tree fails `brew audit`.
  depends_on "openjdk@25"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.10.tar.gz"
    sha256 "2f9b0b50038ed5f088e6caca005639bcd35f5a76e78255241d79541ca030dcb2"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    system "swift", "build", "--product", "SkipRunner", *std_swift_args
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
