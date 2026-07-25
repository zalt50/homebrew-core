class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.5.tar.gz"
  sha256 "2cd480cb1372ed585b26b06a59031a38a6d2f54f678c44885eb54f14c9ecdcdb"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "0a3f25eb5480b7efb0cba14449fa70700e67ddf280b87ed59e8dcd40bcec22a2"
    sha256                               arm64_sequoia: "69bc8e722360daa46eb95dda58155794f58971ff349cd403f5c0556eca5d5ff0"
    sha256                               arm64_sonoma:  "02d9fd45fbfc0dffd2c0ef481f03a8696b73f9c3b9bf04653d46f2979537ba9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35657784e5ead11fcdc3b9fd84edfe3a7939a5575729a06e91cea2f13194c23"
    sha256                               arm64_linux:   "a5759321091b2196a3e96f9ab981737730fa085b91a9be2169822a888dd0c943"
    sha256                               x86_64_linux:  "790bd970e47f007574e812cc78e3e98d144216ec7613bbd426707d7bec786005"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.5.tar.gz"
    sha256 "2d376159d0651cb18894447abae4c2fc5ac1c36e196b639451579d601539bfd9"

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
