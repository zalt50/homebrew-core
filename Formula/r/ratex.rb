class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://github.com/leoliu0/ratex/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "03f60467885ab3bc047044edc16511fd5cf5735fc4ed26be5c662def4954ebfd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b4be39a9fc8b3c8400dd4027d977dfd29da73a319f444cca5696301a19f9ea7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94a6b62869c558d38c34226ddbf015a415d6c003ed775f978bfe629981408d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "897416b79b37c7e5386732d3402c68f7a98ee14273a44b489bbc665d34b39f6d"
    sha256 cellar: :any,                 arm64_linux:       "03ec9c159613f69a4b7d5836a388b7036b89cc94647aae6a5ccc5829580d6c29"
    sha256 cellar: :any,                 x86_64_linux:      "cf02dc6ca3a725527494c760ddee10866424dd6fb96773ff6f8ae58a93a32fd8"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Every bin embeds the package archive, so linking them all OOMs; `ratex` dispatches aliases by name.
    system "cargo", "install", "--bin", "ratex", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "ratex" => cmd }
  end

  test do
    (testpath/"sample.tex").write <<~'LATEX'
      \documentclass{article}

      \title{Test}
      \author{Homebrew}
      \date{\today}

      \begin{document}
        \maketitle

        \section{Example!}

        This is simple \LaTeX file.

      \end{document}
    LATEX

    system bin/"ratex", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end
