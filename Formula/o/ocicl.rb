class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "92cbd9cd16de5c8b5038e09ff8fc1dff589b93e8e8edfe9c0d68087b9e9ebe85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fbe29883b09d9d2573f1702ac1387dceba793591948858d0e2d9c8109d68004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "399f95c678c456682006e9c177ec92a5628a2dc46602680b8535678b8662c4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac3a038d86d2c4ae6638c5ced11198412dea4176473602dcc81fa32f4ac44cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d1a645ca07526a4c13c4601be08cfcce8cfe13ab52bb611f8a1319b9afda62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d969d59fdae91bb6704dc59aaf5e75c366f52b6ad483ba91162bd92031d285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "622d1a370a3f64adfb75829e448a13fe8e4b9def87fbc8494351457d25cec266"
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
