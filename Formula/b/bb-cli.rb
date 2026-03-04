class BbCli < Formula
  desc "Bitbucket Rest API CLI written in pure PHP"
  homepage "https://bb-cli.github.io"
  url "https://github.com/bb-cli/bb-cli/releases/download/1.4.0/bb"
  sha256 "38870c080cfd029204d7399ee60c656e3865633a805fc8dae63819b7ef21f098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6e39224aa02067b7a78bfc90146384a68c1c80afd67c013e70ae0e6b97740ee"
  end

  depends_on "php"

  def install
    bin.install "bb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb version")
    assert_match "No git repository found in current directory.", shell_output("#{bin}/bb pr 2>&1", 1)
  end
end
