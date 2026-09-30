class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.11.tar.gz"
  sha256 "2933e81544fb35b7e31e9649ecd98eee1e6ad8bda99bd2baadbe5444a8a120a5"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28a49659bac9efccfb2359b2edc7a9bc4510faff5435d5eaec383496d984476f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1f288f0803b6efee0655cdbe94d27023cc4acc75bbd682d39e135bd3a1d2302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96ce707052847e3b3223e8b431c6deea39abfcad14858f2f3a4d9b3f59bd4280"
    sha256 cellar: :any,                 arm64_linux:       "0afc30a8c817c249444a8e566baccee5e90df09ccab9a9c45575272c38dccae0"
    sha256 cellar: :any,                 x86_64_linux:      "e747a7951991beff1663d859663067d36fb3ad34a3cd8e2c0a7397e73b291a29"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "python"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "bkmr/Cargo.toml"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
