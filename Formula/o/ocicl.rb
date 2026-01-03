class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "5f3d1292c20b0b43f8230cde9646ee580c4a842b512a9f959508b38d5b2a297f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd1c2ea07acf5c49c356de1dd38b6fbcb22afded28a1024b82bc180dd944edb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8962314d12d86b1ea87c78362db4c7a6e6b8ffec92c3970a4c1f27876638f1bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc194e3d7c3964279a37e8cdffe7f73afb385f6300783cf80ce5de1b3afec88"
    sha256 cellar: :any_skip_relocation, sonoma:        "f24b5957f7525159564e43dde47abd5baa907b163e65a3e57236d711f496f9b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3a5a42a3999f9a45b4bdcd86d02844483dd285163d061802d81ce1a307d0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7bb5a9ee25d7d2c54d1f98cbbc36b6917bed20e17dd70de7ea88cc1824e12b"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
