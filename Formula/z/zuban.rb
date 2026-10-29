class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "70b9ee27d93d1615cbfa24e7e40d44698066e2e0723383554a9403bda3e4165b"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c697e804eeb65ae74496ac245e0a0ed9a2f94bd96ab0f58d93af0cdcc8dfa6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "047142ce75e2e9e288e8e1cc7dde56e130d2e48b43cb9e371a1cf34fb982dff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fc98660220ccfa4ce7a0d3b385e7db82c5c0ebedeff66c1f4f623d57bc2f66b"
    sha256 cellar: :any,                 arm64_linux:       "ad2275a6d4083b79ada4293e215ed34a24a704dc82098cf0abbb1091da14896b"
    sha256 cellar: :any,                 x86_64_linux:      "de60cbdf1f18fc5c27d52f2a8f62a6bbbaee0627b507454350786fc51419bd64"
  end

  depends_on "rust" => :build

  resource "typeshed" do
    url "https://github.com/python/typeshed/archive/e75a39fec6f375f5002d54c5607b44bedc025a4b.tar.gz"
    version "e75a39fec6f375f5002d54c5607b44bedc025a4b"
    sha256 "05c0f2faeaa57766ace6f334e9aa667e5abc16a6f611f0c9b1b42c92d8676f7f"

    livecheck do
      url "https://api.github.com/repos/zubanls/zuban/contents/third_party/typeshed?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/"third_party/typeshed").install resource("typeshed")

    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end
