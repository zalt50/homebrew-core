class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.11.tar.gz"
  sha256 "da5280142a7537ad4424e6b420128d01edc24a0be6e654b60f8f44f56ffb4a85"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "c86579f9e3bc9435d3d171f74623d6e18914db9dd21fbf82ef30cffd6883dcc5"
    sha256 arm64_tahoe:       "d9907b253aaeb6e0124ed5d98c427ff100cff5a08ba47071d280f37508c122ff"
    sha256 arm64_sequoia:     "1b90d7ddfcdd8d20f90d06e0a20b2d239e77c0ca5bf5fa0061206bfabc7d3e15"
    sha256 arm64_linux:       "7750a533c47335e667320b420ec5bf04cf75f73dd9df52c279197f80cbdfb172"
    sha256 x86_64_linux:      "15f5cae8b62b0991b142813de70be63190882bc04fc31ca84d48e18de672bede"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.11.tar.gz"
    sha256 "ac55fb432f02460df5acba18f3ad814be9d2cb970b38ad0917ff7ad010acd8c7"

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
