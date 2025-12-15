class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.0/uriparser-1.0.0.tar.bz2"
  sha256 "0606f62fa9522ae208173bae5258a0d3357961044417ae5ef18dad5ad26b74b1"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5c4f9193621690a1de4ce6f5ae18f623362314a05762e3b5f7082d61c771854"
    sha256 cellar: :any,                 arm64_sequoia: "e2c29d08c85241f773b135ee33da1ddb8927b7c54c82130fdedd5de90a1b1422"
    sha256 cellar: :any,                 arm64_sonoma:  "a630502ffbbf1043adc36494c0323bb8769ef9f90b2fbf0a682ea69bd7f052d3"
    sha256 cellar: :any,                 arm64_ventura: "f516ff326638f85478d18d4d68ee8ef700094465610ad77d5334145f80ae86aa"
    sha256 cellar: :any,                 sonoma:        "16c96a36df667b883749319d432e153a17ba8b92d4e095842372393cd56e1eda"
    sha256 cellar: :any,                 ventura:       "0d58050aad70cd35e623b6f166035c83239ab5cac6602a618f7b8574caa78206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d6268670d5d5700b71984169dbced8cfc9f9e0416c23efcedc29825f447464c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc58cbb61b010dc4464969c6af86038df87e03b858e3f8164faeeb42993945f"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DURIPARSER_BUILD_TESTS=OFF
      -DURIPARSER_BUILD_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
