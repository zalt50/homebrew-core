class Netcode < Formula
  desc "Secure client/server protocol for multiplayer games built on top of UDP"
  homepage "https://github.com/mas-bandwidth/netcode"
  url "https://github.com/mas-bandwidth/netcode/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "bb39da04c7a1c85b74135688e1d906acc751fb98b66647d532fb28f142ad913f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ca45050c28d0928feedd0aa18a638abc534ff0840132ff77040c25570977d63"
    sha256 cellar: :any, arm64_sequoia: "971c87f0d0033195bc7127b2d4ded753cd6d5e2e5ef9b97f41a26227ed18b9fb"
    sha256 cellar: :any, arm64_sonoma:  "f2413c53dc2270603d63f1de6e5250438ad8da77bcb660006285b108336903d8"
    sha256 cellar: :any, sonoma:        "1b060a13c9ea87f3b5e62919b3d451f06e265d9303a1c9668c5c94c4ae508a7b"
    sha256 cellar: :any, arm64_linux:   "be4ade75566c8cd2bd428cc4b364358e1cb9865a3a9db484002fb8bd98b5ecc2"
    sha256 cellar: :any, x86_64_linux:  "4867527c4356ab35690b058372ca95c38404c33e939b07356b97dcd08b000388"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnetcode", "-o", "test"
    system "./test"
  end
end
