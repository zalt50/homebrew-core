class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "e22ae3743cbfaa626f82c71ce892f05de1be826b6d597b2644fce55b37295a52"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "35e7346fb97d5b9916ca6290a6946b39318e7bb47d52f6bbe81e527f4296bc02"
    sha256 cellar: :any, arm64_sequoia: "91a2f0bb20db2d85cbf22f2f8aa9964c1455cc4fc855372770228e2f15cd18ad"
    sha256 cellar: :any, arm64_sonoma:  "90627863df0b4c2894c27ff3864092a2248867052a4b9b406199561af82e8bc8"
    sha256 cellar: :any, sonoma:        "4e9221470c650710030143bea86e03b794fb865b0a91e06bcf40aab8d8893164"
    sha256 cellar: :any, arm64_linux:   "63269464ad5481c2e9f27e1a223d3256c6c44d575b24843a0f9b83e5b75426bc"
    sha256 cellar: :any, x86_64_linux:  "1bfe327cddc4d54a540869f58d4a2e55829544885edfc3c4e235378d8c2d3c5a"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
