class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.51.4.tar.gz"
  sha256 "53be611af98caa2a857bb993bc3a0263007ac75909fe64c7ff23a84bc0f303c1"
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
    sha256 cellar: :any, arm64_tahoe:   "02cd11a3967c5b1f524c9ecdaff16f9a8c5152b63308286d06689ba32eb65b10"
    sha256 cellar: :any, arm64_sequoia: "8eca3c28456900398e7c7e8a105654b7ad7221d4acc33bb77409c8639b711409"
    sha256 cellar: :any, arm64_sonoma:  "f731a8e9b7d1a4ed4b71ef4573a7d3af1bf91cbe21612a850e380bf28338ba6a"
    sha256 cellar: :any, sonoma:        "c4dc2843ffa651bdff737163c8f11fdf561cbc85bc3eb8671b8fdf2ccf0468b2"
    sha256 cellar: :any, arm64_linux:   "2c43fe46500db232c349888b715f930106ca186ef46eca16bbbad7f812b5f3a7"
    sha256 cellar: :any, x86_64_linux:  "ff4af107cf9d15ecf37e6ed32706a37438f4c3b12220ae199f8a5a029fb0ef91"
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
