class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.10.tar.gz"
  sha256 "41671a3121345fb6b9f98cf41609379ba379c0aaf86be9e862f87a1d69a40e89"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e14c2750612d7c309c6cfb4d8fe01d7fb94ca916ff0990378d7d0693dd39a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e14c2750612d7c309c6cfb4d8fe01d7fb94ca916ff0990378d7d0693dd39a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e14c2750612d7c309c6cfb4d8fe01d7fb94ca916ff0990378d7d0693dd39a64"
    sha256 cellar: :any_skip_relocation, sonoma:        "47aaa1633f8161906f6ef7cae6cd7a30bb87bfaafb665977e0d1fbda61efe82d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3749467807e9b0664808f44027664b3dc715a40b424881c044e34dd3c275daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9a5b240b366cf9701d4aa474422e27c36af4c06af187a7d2232d8e3825b38c"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
