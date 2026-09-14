class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v48.0.0.tar.gz"
  sha256 "a4c0c0f7a78266ec95716ae32b38e14a6035b105eb7779fa15d9b6310c10f2ba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33b96607aecc240f119e633d45b36929aceddf181af0dcbb12d2f2f7bbc903e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33b96607aecc240f119e633d45b36929aceddf181af0dcbb12d2f2f7bbc903e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33b96607aecc240f119e633d45b36929aceddf181af0dcbb12d2f2f7bbc903e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9868b6fec7458999d81462fb9ba571a3198c63a440977a92b6255a98fbf55d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9868b6fec7458999d81462fb9ba571a3198c63a440977a92b6255a98fbf55d2a"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Use our protoc rather than the prebuilt one from `protoc-bin-vendored`
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"from.json").write <<~JSON
      {"//app:leaf": "Rule#old~old", "//app:top": "Rule#top~same"}
    JSON
    (testpath/"to.json").write <<~JSON
      {"//app:leaf": "Rule#new~new", "//app:top": "Rule#top~same"}
    JSON

    output = shell_output("#{bin}/bazel-diff get-impacted-targets --startingHashes from.json " \
                          "--finalHashes to.json --workspacePath #{testpath}")
    assert_equal "//app:leaf\n", output
  end
end
