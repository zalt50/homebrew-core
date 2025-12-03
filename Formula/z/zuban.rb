class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.3.0",
    revision: "a159f755ca4bf8307a0cab01494ae2526437eb89"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b54fc05f151da2aeb25b97e36c07b8b8268b48ff7b45fa314fb8666087e335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886b626ae0f97b784dcf31e5566a85802d4e92afd7973d5d93c76ac848257620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a965c7ac5433881808cf78dd703a452d28f88c59728030b459d60a5a877576c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "665373eb3e32d46d1c9be9fd32c38521e49b830029709e1f211de8f274878a74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b527ef874b11144f0260edd8241d3520b73ececbdeaf03d3867ffea073383518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f7db114da498edfd70442dafa292dfa1aa8dc65be7d1db92f4e176426bb0f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end
