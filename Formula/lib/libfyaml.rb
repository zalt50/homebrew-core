class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9.2/libfyaml-0.9.2.tar.gz"
  sha256 "d76da1dcc91f5d74cb9812ecce141477be93a258001e05a268a86715c0eea098"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3ea19ebfac0717aeade3dbd3e01c051e915887f88e44d0869b1e0a04fa379ed"
    sha256 cellar: :any,                 arm64_sequoia: "0e04b50c675dd473f2f55dd9b62950e4b4b7e16202abe67160b76b5dc02d4c3e"
    sha256 cellar: :any,                 arm64_sonoma:  "76ec397532cdc6cf1974209cb70ed634b6b6ed185db026080c6a0f84e31d975f"
    sha256 cellar: :any,                 sonoma:        "dbb0c19f197f1e62e425bbc59aae052854607a29a1f30dc2935a876d6f109ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9df8155f432550e8d344d41847909330c8debdfbaf9e618a557517c7798785dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e83d09a481791be4d2dc101620e3e1b125200bb86b5823c04bab0c3b13e9826"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #ifdef HAVE_CONFIG_H
      #include "config.h"
      #endif

      #include <iostream>
      #include <libfyaml.h>

      int main(int argc, char *argv[])
      {
        std::cout << fy_library_version() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("#{bin}/fy-tool --version").strip
  end
end
