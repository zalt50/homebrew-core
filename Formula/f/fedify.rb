class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.4.tar.gz"
  sha256 "47b7c0059906430313dc41ac9c956b5416070b09f82bbdba966eaecbc49b1379"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bed00a7971079c383034bb6b5e574ce01e065b1527521dcf7b9c4d7d016c01f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faeb08f4f2157445331d04003b89f19081492efe766ff9255d6064b4712081ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5150e473f199d1d6e56c8ac59a6d532a3cc636ec1314e2c4591ba0f99e18417"
    sha256 cellar: :any_skip_relocation, sonoma:        "d714b90d3c0108fe19d8144f323c27dec92efcabb25067ae8012ecb6811af448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d7e6094303ac64f79dedd87e886cc28bd2f3c9d7a977eff3cbce49ba17b75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871ca573d36f1cadc0272e1e358c2b1cd081909760511f0c5ccdf52e1bc638c9"
  end

  depends_on "deno" => :build

  on_linux do
    # We use a workaround to prevent modification of the `fedify` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  # Fix type error with Deno 2.8+ where setTimeout returns Timeout, not number
  # https://github.com/fedify-dev/fedify/pull/789
  patch do
    url "https://github.com/chenrui333/fedify/commit/fc77c0003620bed0ea20a002fcdf52f56864798e.patch?full_index=1"
    sha256 "8fb3d89a946924573020391e39f5497d178283848bf4a18daa4b9fa2b33bff77"
  end

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")

    # FIXME: patchelf corrupts the ELF binary as Deno needs to find a magic
    # trailer string `d3n0l4nd` at a specific location. This workaround should
    # be made into a brew DSL to skip running patchelf.
    if OS.linux? && build.bottle?
      prefix.install bin/"fedify"
      Utils::Gzip.compress(prefix/"fedify")
    end
  end

  def post_install
    if (prefix/"fedify.gz").exist?
      system "gunzip", prefix/"fedify.gz"
      bin.install prefix/"fedify"
      (bin/"fedify").chmod 0755
    end
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
