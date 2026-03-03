class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "4fb0f24c0296fa04be170e964999bad7f101d0e71a2409a044e9f43053393e0d"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "599f02083d6463945b263c2428f8088155d8e78acf992fe7878ab4ffb5f9eb20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17dfb8fee0935060618ad6a00dcd340a9dbecee479993147c42eed461fb5ec4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170b9a347c574be1ddce878b81d61f0f7dea0db910f09492062ce281f1171bc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d396d8afeb799bac3948e6b8b3332fd880aeb50ce7612358d0e553009b5a759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49acbb7c506ea9445cf4c05d569d5d2b1ebe47c596b92eed0528abb49cd3e43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e2b629e737afe476bba958b1bd2304a2db9d944f471f96a7a889b37e3c26e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flag \"endpoint-url\"", output
  end
end
