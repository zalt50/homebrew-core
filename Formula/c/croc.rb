class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.3.0.tar.gz"
  sha256 "ca0ee9694ddc98ca55f77cf9d8eb123af10bf8674fec8e356c2edc43f5705532"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3449c091612da575dfcf6ad355ff847da3513e0d3986be272214a91169cd7f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3449c091612da575dfcf6ad355ff847da3513e0d3986be272214a91169cd7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3449c091612da575dfcf6ad355ff847da3513e0d3986be272214a91169cd7f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "410e60594d71b95615bc13a45115b37b4b339e8db2b77d43af87c4510b88a7f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c45f2f900023f018f205ef92f8a9da974409fab19164a23c507c0e24ff0489a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da5b6e9f77f00f356cf5a17ad32f4027fe3bdf5682233b88ea52753ac62797e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
