class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  stable do
    # TODO: Switch to monorepo in 5.5.x
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.65/ortp-5.4.65.tar.bz2"
    sha256 "4ecee5c64b60c8e0b34f6c44cbfd022705d5a06bddbb010e442c4c5503e7022b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.65/bctoolbox-5.4.65.tar.bz2"
      sha256 "0cb41b759b19dd24cf29847c2bcf96ac0c68cdd210c0b0ba862d43ebaedb35f2"

      livecheck do
        formula :parent
      end
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f4036d6d1ecc587ac38b917c9ee7212ee3f873268530944514443de49dc4b98"
    sha256 cellar: :any,                 arm64_sequoia: "c94660b5863e83e14d30b129570068bdb89ad7546e64f203829acd62aaec32ad"
    sha256 cellar: :any,                 arm64_sonoma:  "95016dbdbd9baed93e2e51c8741d4d2c1b44d6b7bd540f0635d1646de3a18420"
    sha256 cellar: :any,                 sonoma:        "b5e18148def0f1df105de7a3d158514df5186940e417e67726070dcb3bd4f2de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1c33177868c6be84da67fa32435220dce3321f52fcbbc0241c693dfd2a858b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c160aca28623991d9f61817b8621ba76458056136bc250da335d47ae9f7566b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    if build.stable?
      odie "bctoolbox resource needs to be updated" if version != resource("bctoolbox").version
      (buildpath/"bctoolbox").install resource("bctoolbox")
    else
      rm_r("external")
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", (build.head? ? "ortp" : "."), "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end
