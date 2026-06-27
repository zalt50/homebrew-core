class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://s3.amazonaws.com/json-c_releases/releases/json-c-0.19.tar.gz"
  sha256 "37ad0249902e301bd9052bf712e511fcc6acff4ecaad4b5900aad9ce564e26de"
  license "MIT"
  head "https://github.com/json-c/json-c.git", branch: "master"

  livecheck do
    url :head
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb064fc1c259000bed8cc895e41a429a1afec18235e37fc32e9d0711d4d30b80"
    sha256 cellar: :any,                 arm64_sequoia: "c5514d30b5249b6d2a92e4dff45f56e2b081aa8811d13a20c84a3b911f6604d7"
    sha256 cellar: :any,                 arm64_sonoma:  "16b53cbbfaa2361f7e68f112f8ce706bc3d59738f377a26a1341c7122956e9b3"
    sha256 cellar: :any,                 arm64_ventura: "e6da2f2e625b6d6cf141bb4c3fe05ff0d1d42617321da078b48f32c9b01ddb0b"
    sha256 cellar: :any,                 sonoma:        "9630b473e74aa113e050b6ba4d3760d3f0d7c67c6460855217b312c597253eea"
    sha256 cellar: :any,                 ventura:       "91286eebfd88f8989056b56dad509e5b42aadda51e29708ef550da8a6b3314ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3fe7e9e1412e97926ce0716633d5f7ee5f8f22de5f9d59cbb31900b4cd6c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6afd63b22756b317e0dd21aa71644f47ec11996366bc60c8d5c9306f87044caa"
  end

  depends_on "cmake" => :build

  def install
    # We pass `BUILD_APPS=OFF` since any built apps are never installed. See:
    #   https://github.com/json-c/json-c/blob/master/apps/CMakeLists.txt#L119-L121
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_APPS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-c/json.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-ljson-c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end
