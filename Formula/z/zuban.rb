class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
      tag:      "v0.8.2",
      revision: "eb1aaf55eb1b4d8e17917ec436af416b413052c8"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "876d9f68e32b558a8c93b32df26abc4fef3f885e8289b8ae9f75b88ca4fb3a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2430fc2f10b0a6ecdd2603da4f087cb129e3b055aa1abd7846aaa6bc7042e631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78b574866c925596d8350bd45ec98561fbd99247532a0f9441b09d8a615e975"
    sha256 cellar: :any_skip_relocation, sonoma:        "17cfbf38b438f8d451b2485e0bc1fdc90a3ae27279e2930d1d9347d323969f59"
    sha256 cellar: :any,                 arm64_linux:   "9c0dd5d932e36d13a1e6654ed47c682be4d059716ddec9d7e811240b9c20cb45"
    sha256 cellar: :any,                 x86_64_linux:  "bb0d77015a432fcfa9a871ca70568f61af8aeb93def4c29a6d662419e4512eee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
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
