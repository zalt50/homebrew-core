class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://github.com/teamtype/teamtype"
  url "https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "eabc7a197a6d5f1a06855d168796f5db95e1d61cfe1cb9cb05ce6f4e3cec7cb9"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "daemon" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamtype --version")

    (testpath/".teamtype").mkpath
    expected = "For security reasons, the parent directory of the socket must only be accessible by the current user"
    assert_match expected, pipe_output("#{bin}/teamtype share 2>&1", "y", 1)
  end
end
