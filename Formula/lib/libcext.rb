class Libcext < Formula
  desc "C utility library for Common Pipeline Library (CPL)"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cext/cext-1.3.2.tar.gz"
  sha256 "622532430a63ad26756eb51751c1815c96bca4722ca30cb961ebb35a2072201d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cext/"
    regex(/href=.*?cext[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cxstring.h>

      int main(void) {
        cx_string *s = cx_string_create("hello");
        printf("%s %d\\n", cx_string_get(s), (int)cx_string_size(s));
        cx_string_delete(s);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcext", "-o", "test"
    assert_equal "hello 5", shell_output("./test").strip
  end
end
