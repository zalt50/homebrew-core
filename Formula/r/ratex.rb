class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://github.com/leoliu0/ratex/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "9301909678a06e6ce583dd42c8aeb51e3b595d2dd7cc7f9a45b459603f312cb9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a9dab8a7c51a279bcac21eac18d767eeaa76ddf4b8d5058bf10b0b73c9dad44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78f8fadf85085c82b38b5c29f5c626f4772f4ba81e2cbf02a99190951383dd4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28ad8a2fff6a7a466ab0b2fe4bd5b90676eb4ca9a394fac29214b852eda3d674"
    sha256 cellar: :any,                 arm64_linux:       "cfe3dbd2a3a956949dee0571f568fb13d421268806fbdc7e400fa4843157eed0"
    sha256 cellar: :any,                 x86_64_linux:      "f49e8a5ace3985496e23f452838e0e2c1c08c3f42d5c9bd926ec5ce1131bab27"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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
