class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
  sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9891bd49f258c2938b83836301b897d5233bd5674cf376f9acce3faa387fe21c"
    sha256 cellar: :any, arm64_sequoia: "fa22ff97d66e66239b52785025ed16ecd3c3f0503ffc7f3c45f2d50522811548"
    sha256 cellar: :any, arm64_sonoma:  "90eb5cb97727b360594c1ad5754e50914168e9d79b2b1f992ac49888b6fab4ab"
    sha256 cellar: :any, sonoma:        "a2e44885e2a7f256c67adede77bcae36952ec5b44c6ca6ce51064cf4f3633e9b"
    sha256 cellar: :any, arm64_linux:   "90348d1888a871b1127b6d8c108d35db52039153546b388509bb692bcd893b08"
    sha256 cellar: :any, x86_64_linux:  "de4ea069b065799b8c8167a69030b0e248e8aced5743a69e5d5fcb6a3554e8a3"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    PYTHON

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
