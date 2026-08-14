class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.4.0_src.tar.gz"
  sha256 "d31716ba9d2d96de9c664ed5006391e834dae54dcda574f1cf0bf7d074866333"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ace35aa1b533a55be8d56aa1fabb6e6b2b7f246364f860fda3cb44b397da9f32"
    sha256 cellar: :any, arm64_sequoia: "b5459816667e6c4fe3aae5ee4e02353c54578e4661fc7f8ca70dade61a95157a"
    sha256 cellar: :any, arm64_sonoma:  "3cd052ca2e577a484cd7c3ea0da5bf809be89629c6dfd698126cf3fafd520b5d"
    sha256 cellar: :any, sonoma:        "d3849ca493e07b6531fa4ced73269040855583108e3ff6890271bb6d1c59a55e"
    sha256 cellar: :any, arm64_linux:   "e15149501b274a4382cf21ff5361282320c5c53710dc6f94c52bd319657365a9"
    sha256 cellar: :any, x86_64_linux:  "b45bbd5c4c6ac348440551061c1fc71fb243d04b852b8f6d0e9c0a90ebe28598"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "ffmpeg"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "sdl2-compat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

  def install
    # Upstream only guards the X11 probe against Android, but Qt exposes no
    # `QX11Application` on macOS, where the screensaver code is a no-op anyway
    inreplace "CMakeLists.txt", "if(X11_FOUND)", "if(X11_FOUND AND NOT APPLE)"

    # The CMake port only links `intl` for Windows, but the old qmake build
    # linked it on macOS too, where `gettext` is not part of libc
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # Upstream ships no `install` rules and names the binary after the version
    bin.install "build/PC6001VX-#{version}" => "PC6001VX"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/PC6001VX --version")

    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = spawn bin/"PC6001VX"
    # the config tree is written on startup; Intel Macs need well over a minute,
    # so allow plenty of time but stop waiting as soon as it appears
    120.times do
      break if (user_config_dir/"rom").exist?

      sleep 1
    end
    assert_path_exists user_config_dir/"rom", "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
