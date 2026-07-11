class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "284871471677018cc218d5e2f4f201f37462ac91d05fb76940eff10a57ebbc6d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "161a0fee9722df21f217aeccc07e2ccc5df412e94caf78ca23ade9e576c6c386"
    sha256 cellar: :any, arm64_sequoia: "08ab618e3361c1390a951bd7cdb4b6b4a42cba77da28c9cd7fecb61bf626b365"
    sha256 cellar: :any, arm64_sonoma:  "68aa94f9b409ec900ef3f13cd3fdf950c06abc4d301c439e54c592297604a890"
    sha256 cellar: :any, sonoma:        "9bd1dbe51e16d4eb7bde5b081559902959a410afc85a8ada7886599d603ddca5"
    sha256 cellar: :any, arm64_linux:   "326011e6bff721a70df609321f030cc1f6e7b8cfa518ae894a896ca5c00c5714"
    sha256 cellar: :any, x86_64_linux:  "ccc55fcb0c9583e61b341c28a183c5a8ade1dda681c925c801e4a93cd2d02fe6"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETCODE_SYSTEM_SODIUM=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netcode.h>

      int main(void) {
        if (netcode_init() != NETCODE_OK) return 1;
        struct netcode_address_t address;
        if (netcode_parse_address("127.0.0.1:40000", &address) != NETCODE_OK) return 1;
        if (address.port != 40000) return 1;
        struct netcode_server_config_t config;
        netcode_default_server_config(&config);
        struct netcode_server_t *server = netcode_server_create("127.0.0.1:40000", &config, 0.0);
        if (!server) return 1;
        netcode_server_start(server, 16);
        if (!netcode_server_running(server)) return 1;
        netcode_server_destroy(server);
        netcode_term();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnetcode", "-o", "test"
    system "./test"
  end
end
