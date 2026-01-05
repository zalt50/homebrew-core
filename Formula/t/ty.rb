class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/19/7b/4f677c622d58563c593c32081f8a8572afd90e43dc15b0dedd27b4305038/ty-0.0.9.tar.gz"
  sha256 "83f980c46df17586953ab3060542915827b43c4748a59eea04190c59162957fe"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9308665bd50de224ad1ca93f26e69a380e47cd6f806e65880b38d8bdfa946133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed6b9489f6cbccf2168f3d0bcab471c4032c2474529ab23665cdac3ae1c58472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d816338576ff52f67b7b81031e4cbee77dbedbbcdfb1a2655868f0d8919d508"
    sha256 cellar: :any_skip_relocation, sonoma:        "905e0f39e8da5fba407f9e419eb746899ac1935d2a5dfb1027e2428eebeb34d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bae7e6498a03b791483918976f2d27760bc30936b23630afa01c453f5215591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e3fb22f04d48f9dc8a530708e5823c7a159156a95c27bba59d04cc02efd607"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
