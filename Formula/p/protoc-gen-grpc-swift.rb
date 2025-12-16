class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.1.2.tar.gz"
  sha256 "5ae934c7a87366c5895c1d788fd6273c3236c1d3f336858aad7a83d32b318c6d"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9de6c9831eb4cf22e9c389f7e5641306edd69336ed862626b6952590e6253f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276f6ea43c29163e84fdc3d0220b5c38916b83ca6bd85570b792f9c21c97eabb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d067aa46165ac2688fe4145eb890db63b5b2ace14d3d53a2eb32d227862aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687e7efac0f3282c348431ba2b8b4496e357c93c9e4cc5c16b92fd6d531941aa"
  end

  depends_on xcode: ["15.0", :build]
  # https://swiftpackageindex.com/grpc/grpc-swift/documentation/grpccore/compatibility#Platforms
  depends_on macos: :sequoia
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-grpc-swift-2"
    bin.install ".build/release/protoc-gen-grpc-swift-2"
  end

  test do
    (testpath/"echo.proto").write <<~PROTO
      syntax = "proto3";
      service Echo {
        rpc Get(EchoRequest) returns (EchoResponse) {}
        rpc Expand(EchoRequest) returns (stream EchoResponse) {}
        rpc Collect(stream EchoRequest) returns (EchoResponse) {}
        rpc Update(stream EchoRequest) returns (stream EchoResponse) {}
      }
      message EchoRequest {
        string text = 1;
      }
      message EchoResponse {
        string text = 1;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
