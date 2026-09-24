class SynergyCore < Formula
  desc "Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "aa1ffae3d1b2333972b42c54f1ae52e75b62e09a597cd0bc32b32b09e4151ae5"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://github.com/symless/synergy.git", branch: "master"

  # This repository contains old 2.0.0 tags, one of which uses a stable tag
  # format (`v2.0.0-stable`), despite being marked as "pre-release" on GitHub.
  # The `GithubLatest` strategy is used to avoid these old tags without having
  # to worry about missing a new 2.0.0 version in the future.
  livecheck do
    url :stable
    regex(/[^"' >]*?v?(\d+(?:\.\d+)+)[^"' >]*?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d71795492e91748665c7a84489e191e8202bc03ea53b89b4cf562e2a7a64dad5"
    sha256 cellar: :any, arm64_tahoe:       "943b18663b65ffb1818fbf0fa72cd59c5037c8ca81a17ca90ba2180dfca3623a"
    sha256 cellar: :any, arm64_sequoia:     "dfe44cc8bbb0aaa82c397562cb275867b4d7d0c06228a60b08bb4d9d60580bb2"
    sha256 cellar: :any, arm64_linux:       "000a5cda373ba98d0399d4fb7d9b7dfa1389ba273bdf31efc1669287af4d5a3a"
    sha256 cellar: :any, x86_64_linux:      "fb8d58163dc366947ad5c37a9e078ba939f908f594bb1db3799fc9e8f3876135"
  end

  depends_on "cmake" => :build
  depends_on "qttools" => :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1402
    depends_on "qttranslations" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
  end

  fails_with :clang do
    build 1402
    cause "needs `std::ranges::find`"
  end

  def install
    # Avoid statically linking OpenSSL on macOS
    inreplace "src/lib/net/CMakeLists.txt", "set(OPENSSL_USE_STATIC_LIBS TRUE)", ""

    # Release builds now require a serial key in the GUI by default; keep it keyless like 1.20
    args = %w[
      -DBUILD_TESTS:BOOL=OFF
      -DSYNERGY_VERSION_RELEASE=ON
      -DSYNERGY_ENABLE_ACTIVATION=OFF
    ]
    if OS.mac?
      # Skip macdeployqt, which copies Qt dylibs into the app bundle
      args << "-DDEPLOYQT=/usr/bin/true"
      # The bundle's Qt translations are looked up in the qttools prefix
      args << "-D_QT_QM_FILE=#{Formula["qttranslations"].opt_share}/qt/translations/qtbase_en.qm"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      bin.install_symlink prefix/"Synergy.app/Contents/MacOS/Synergy" => "synergy"
      bin.install_symlink prefix/"Synergy.app/Contents/MacOS/synergy-core"
    end
  end

  service do
    run [opt_bin/"synergy"]
    run_type :immediate
  end

  def caveats
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading synergy-core.
    on_macos do
      <<~EOS
        Synergy requires the 'Accessibility' permission for:
          #{opt_prefix}/Synergy.app
        You can grant this permission by navigating to:
          System Preferences -> Security & Privacy -> Privacy -> Accessibility

        If Synergy still doesn't work, try clearing the 'Accessibility' list:
          sudo tccutil reset Accessibility
        You can then grant the 'Accessibility' permission again.
        You may need to clear this list each time you upgrade synergy-core.
      EOS
    end
  end

  test do
    # Linux CI has no display for the default xcb platform plugin
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?

    assert_match "synergy-core v#{version.major_minor_patch}, protocol v",
                 shell_output("#{bin}/synergy-core --version")
    assert_match "synergy-core: failed to load config", shell_output("#{bin}/synergy-core server 2>&1", 4)
  end
end
