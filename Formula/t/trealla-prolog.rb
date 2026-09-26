class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.11.10.tar.gz"
  sha256 "f13cd951493411b4952e8a428dd58402c23753dd4683d3314a70a6d471076d82"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "ebd9084e12f046fff8444e536bf035682b8bc4d621669a20b9d69e17db37f05e"
    sha256 arm64_tahoe:       "88fe5433c73b486972e771f3624107efb50aa9368a724e6355b281c0c9d1cbf6"
    sha256 arm64_sequoia:     "168783aff96e88b942d6d42f7e30fe4a23cbbf10b6f64e6538896006a743cd24"
    sha256 arm64_linux:       "0e43ee44c5e7e383185d91e8145fcd98abd722e54cc6718f83300e069e5e3f7a"
    sha256 x86_64_linux:      "1e43b8b4c36cdf954e9a4070936a231557deaee4998d66c086f9161f871394c2"
  end

  depends_on "openssl@4"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  deny_network_access!

  def install
    args = ["PREFIX=#{prefix}", "OPENSSL=openssl@4"]
    # macOS keeps ffi.h in an ffi/ subdirectory, which the build's plain
    # `#include <ffi.h>` misses. TARGET_CFLAGS is the makefile's append hook.
    args << "TARGET_CFLAGS=-I#{MacOS.sdk_path}/usr/include/ffi" if OS.mac?
    system "make", "install", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpl --version")

    assert_equal "42", shell_output("#{bin}/tpl -g 'X is 6*7, write(X), halt'").chomp

    # library(assoc) is not embedded in the binary, so this also proves the
    # installed library path was baked in correctly.
    goal = "use_module(library(assoc)), list_to_assoc([a-1, b-2], A), " \
           "get_assoc(b, A, V), write(V), halt"
    assert_equal "2", shell_output("#{bin}/tpl -g '#{goal}'").chomp
  end
end
