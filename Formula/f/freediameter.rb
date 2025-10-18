class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "https://github.com/freeDiameter/freeDiameter"
  url "https://github.com/freeDiameter/freeDiameter/archive/refs/tags/1.6.0.tar.gz"
  sha256 "0bb4ed33ada0b57ab681d86ae3fe0e3a9ce95892f492c401cbb68a87ec1d47bc"
  license "BSD-3-Clause"
  head "https://github.com/freeDiameter/freeDiameter.git", branch: "master"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "5eafa2b1cff32588e446f38812e5d28bdbbdc3efca9c5d04d3d8c75aadc63c1a"
    sha256                               arm64_sequoia: "3a0fdc3ba68de137c1c7565a2bf1952cf239c35717276e185ef2c57d8f042a0f"
    sha256                               arm64_sonoma:  "77cce28c5fae584b97aefe1d124bf14da292e5f40f62a4bfccb4b545feecf9f8"
    sha256                               arm64_ventura: "a0a2bb922fe5286a90703eaf346ab465702d3bb43040b11f4c49f2b4296ec768"
    sha256                               sonoma:        "40a30f89b5587df10f03275e37b9d17c4ca3a59098f2efddf5e521b9a71276b6"
    sha256                               ventura:       "3b25d64d36dabbcdd24ca3d2c02bf05f8bff8ddcdb764f58d01c3fed25a50e57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f092135225eda295f1bd57f85b49c8b4cdcdf9241878b0d7c9971f28eb5a570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224a65066b5831f9a7c9d07c2f4439075fe60f8e287c3a4e19fbfc163124e5b7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
