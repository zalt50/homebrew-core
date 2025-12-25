class Libevdev < Formula
  desc "Wrapper library for evdev devices"
  homepage "https://www.freedesktop.org/wiki/Software/libevdev/"
  url "https://www.freedesktop.org/software/libevdev/libevdev-1.13.6.tar.xz"
  sha256 "73f215eccbd8233f414737ac06bca2687e67c44b97d2d7576091aa9718551110"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <fcntl.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <libevdev/libevdev.h>
      int main() {
        struct libevdev *dev = NULL;
        int fd;
        int rc = 1;

        fd = open("/dev/input/event0", O_RDONLY|O_NONBLOCK);
        rc = libevdev_new_from_fd(fd, &dev);
        if (rc < 0) {
          printf("Failed to init libevdev (%s)\\n", strerror(-rc));
          exit(1);
        }
        printf("Input device name: \\"%s\\"\\n", libevdev_get_name(dev));
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}/libevdev-1.0", "-L#{lib}", "-levdev", "-o", "test"

    fd_available = Pathname("/dev/input/event0").exist?
    expected_output = if fd_available
      "Input device name:"
    else
      "Failed to init libevdev (Bad file descriptor)"
    end
    assert_match expected_output, shell_output(testpath/"test", fd_available ? 0 : 1)
  end
end
