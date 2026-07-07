class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/57/5f/ff100cae70ebe9d8df1c01a00e510e45d9adb5c1fdda84791b199141de97/cffi-2.1.0.tar.gz"
  sha256 "efc1cdd798b1aaf39b4610bba7aad28c9bea9b910f25c784ccf9ec1fa719d1f9"
  license "MIT-0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04b0f56120f37b235dc1a8063149e279bad1cc9132727b25158393db8c930c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c87ffc33c6042cf8c12508099ccbed120d6b76ecef0e0745d728960d48e13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d588e61a2f80a3c6609fe497c391fc01dc24e2af1fcae3a520a353af32bc827"
    sha256 cellar: :any_skip_relocation, tahoe:         "1252a16612b1585b96a870ac5c1d0af6beb31c1cfa76449e6599f87b5ec81698"
    sha256 cellar: :any_skip_relocation, sequoia:       "050dfb668072267e2bb9e2eb03a02b31f6d15ecbce1c823ab0af521da3f05223"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c34aa7a07dff752819c015de41f2ba14d42441cc07cd7e4a4be7fd8baa8083"
    sha256                               arm64_linux:   "cb50ba60bbd5cb6b2da0637c3f3090d07d3a68665076c5f553c65bfb061b1734"
    sha256                               x86_64_linux:  "bad3335bd82f947b8283832392a0c37035e500e5732dd63b0f9878dcaf05d639"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "pycparser"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pycparser"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"sum.c").write <<~C
      int sum(int a, int b) { return a + b; }
    C

    libsum = testpath/shared_library("libsum")
    system ENV.cc, "-shared", "sum.c", "-o", libsum

    (testpath/"sum.py").write <<~PYTHON
      from cffi import FFI
      ffi = FFI()

      declaration = """
        int sum(int a, int b);
      """

      ffi.cdef(declaration)
      lib = ffi.dlopen("#{libsum}")
      print(lib.sum(1, 2))
    PYTHON

    pythons.each do |python|
      assert_equal 3, shell_output("#{python} sum.py").to_i
    end
  end
end
