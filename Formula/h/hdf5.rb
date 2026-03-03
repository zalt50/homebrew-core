class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/2.1.0/hdf5-2.1.0.tar.gz"
  sha256 "ce7f5515a95d588b8606c3fb50643f8b88ac52ffbbde9c63bb1edca6a256e964"
  license "BSD-3-Clause"
  version_scheme 1

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae6cec3e48d2f3ace0027a8ae722494911048a9889bb2e0a6785687a3d0c2bd8"
    sha256 cellar: :any,                 arm64_sequoia: "b023689b62eeab2d1be5c814d8877c24b70d09147c08441752ea836c4491c47b"
    sha256 cellar: :any,                 arm64_sonoma:  "ac477526c4f5405c6bbdb81bdbff7bf7d9da42e40e0bbdfe3d48498caf8c803c"
    sha256 cellar: :any,                 sonoma:        "09ff5ab1eff3f2b6767c2f52103418d31409c796d6cb7914d7a03e062f212012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e8b27ef73eda4843dd686e751bbb43ba096406209f06f099f94ba37e68e2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d20eb636a2295c21b7498d5a39ed30634df1b9a956bcae089ef0df7ec9f2e8"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  # Fix malformed HL Fortran dylib version flags from a soversion interface typo.
  # Upstream PR ref: https://github.com/HDFGroup/hdf5/pull/6267
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/bf2c70a3d2a428be67a2273e0acdc97c622c0aab.patch?full_index=1"
    sha256 "ad83d07a9f3de540619f55ab12b8997b463cdb804eb07cac790f556ca55b4517"
  end

  def install
    # Avoid c/c++ shims in settings files
    inreplace_c_files = %w[
      src/H5build_settings.cmake.c.in
      src/libhdf5.settings.in
    ]
    inreplace inreplace_c_files do |s|
      s.gsub! "@CMAKE_C_COMPILER@", ENV.cc
      s.gsub! "@CMAKE_CXX_COMPILER@", ENV.cxx
    end

    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %W[
      -DHDF5_H5CC_C_COMPILER=#{ENV.cc}
      -DHDF5_H5CC_CXX_COMPILER=#{ENV.cxx}
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
      -DHDF5_ENABLE_ZLIB_SUPPORT:BOOL=ON
    ]

    # https://github.com/HDFGroup/hdf5/issues/4310
    args << "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16:BOOL=OFF"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    C
    system bin/"h5cc", "test.c"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~FORTRAN
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error /= 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error /= 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error /= 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error /= 0) call abort
      call h5dclose_f (dset, error)
      if (error /= 0) call abort
      call h5sclose_f (dspace, error)
      if (error /= 0) call abort
      call h5fclose_f (f, error)
      if (error /= 0) call abort
      call h5close_f (error)
      if (error /= 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error /= 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
    FORTRAN
    system bin/"h5fc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*DECODE}, config
  end
end
