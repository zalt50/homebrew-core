class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "f36097bd9f7db9b3d6dda1c987c9ffe43cd05cd2cb17429f7523e9fe66e7f51a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37cdfaf07b33e451e5ba2ccda69ef69c376923a5288a299c307f904642d4dfc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa8578bdb7b2c5b08ece260023cb126194ccd4eaf0c452b7cec764e06483a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eecfa842c0c66395135e8bf3a1c55b822d3d2a3fd5160d29e82f94cdf638fa48"
    sha256 cellar: :any_skip_relocation, sonoma:        "26170068df9d96dd160c1c8424aa4f916bf568c1bb4fb00f39d5efaec528ad88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69fc772f610f4517fb2edece3a803939dacc7ca0a2a8b1549c45b0e7d0c22db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ba88dcc5113e2943e0a2098416d27bdd94265f4ac705a8f7ca605a132d6460"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    (testpath/"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http://localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--ignore-ws-check", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
