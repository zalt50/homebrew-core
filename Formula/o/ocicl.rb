class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "5f3d1292c20b0b43f8230cde9646ee580c4a842b512a9f959508b38d5b2a297f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68225ec5f6779f80fcfa586244f01139aed476db0618e676f43a45b42d0f9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035ee432f7c974ec4b6cb41722ef68e94bf25673ab596a7b3508dbfe1b978e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df9f7cf00151fc34723b7bef113972f49e79bda3dfb776b8a21336426b4e7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4f7b0378a289106e106a8e09903e8066d729109134ecfe78eabeea6bed5de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a94d8835a334ab0592f1fadae9da7c3c9b01f18ad03021536b7f9b0120b029d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf25d879507efd2e442413456bbc6a0aeccb2d993a337e2279189af4ae1d4c56"
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
