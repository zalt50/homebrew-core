class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/argotorg/solidity/releases/download/v0.8.32/solidity_0.8.32.tar.gz"
  sha256 "b3e0a0def18720b5d11dd454f3de4495f52f719dd059a90b4712ca5efb4cc607"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "395f4449159a59c229963a10e373b7f61a1d78558001bbe786f374fc1d660fde"
    sha256 cellar: :any,                 arm64_sequoia: "a8d51c1c86d7e10ddec6504fba2648ffb2522699212f94c88344b93ff2d04b3f"
    sha256 cellar: :any,                 arm64_sonoma:  "ab742980539de5eeeec3d8ca5ae320ef24ba4497586bd175543a9da017672510"
    sha256 cellar: :any,                 sonoma:        "2908d51b79b192acf6400f2781d9f0c6b1966d2346ca6112668b16156d0e83ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66caafeba2cc1af8519b3cee8f8e73a09894dac3b60e597c27cb3f6030aa3264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c467fa0964b2b7431b3d54b5dafa30c4f886b14ce928940281e88f38c8a6e3"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "z3"

  conflicts_with "solc-select", because: "both install `solc` binaries"

  def install
    rm_r("deps")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBoost_USE_STATIC_LIBS=OFF",
                    "-DSTRICT_Z3_VERSION=OFF",
                    "-DTESTS=OFF",
                    "-DIGNORE_VENDORED_DEPENDENCIES=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.sol").write <<~SOLIDITY
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    SOLIDITY

    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end
