class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "cfe921da29aaf3877531837ee5fac244555f619da9ebc948fa135790dfe647fd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "495aee02cd51f3bb0d3da549e2ce9931eaeba6fc77f2a4becc9d60a8690753ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f531f0b8fea4901fe67d09751f28a61835e1041520a368407d1d23bf653003d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f642d14428d7da1a889e5910654f308126dec813a0bf112fed3386c54611ef99"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a55b8b6ff79951007c23147aa795347dac45e0bf090a1ccd2f785231dd3686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d8dfbd862132505f0c139e9f307638e303b94fdbac8e37699de704e2a1f35a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0718d26fffe89e992c6567977004e85f61f16245406d08fa79110b8d58548523"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
