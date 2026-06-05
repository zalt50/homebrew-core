class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.5.tar.gz"
  sha256 "fa25bebd0eb4e2e25ca29e5460668f79e044801f92f913c48db5f35e7b18c7e6"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abbe06d8418708983a659fe15c15ee89c2259306a5663ffe3a3fae1bda295b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c49e6bf9b74f929e3bac6e33375614f30b2e63c3e5f2137cb1acee3e3e00cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5fa8a85989924556950c97822ffe1da1d1b914b2a9fa65066c7249d5531a44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "16946400151cdcde54918be8ee993892321b68277787bef71ac45d80f700762f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "290d949e8868b8806b35036ec60aa077f42f268644407068a8e036dd0daac39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170ed3cfdd705c7139603f30b4bae530ac4642d618f4109366a7da3046c70f2f"
  end

  depends_on "deno" => :build

  on_linux do
    # We use a workaround to prevent modification of the `fedify` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
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
