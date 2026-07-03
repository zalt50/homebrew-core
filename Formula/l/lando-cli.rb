class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.26.7.tar.gz"
  sha256 "f59119897f99516a64e7341fcb8a616e270cd4b1290584bb183563b6f42400b7"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9edbd403a98f78d00d44169dfaf4b4a09e96b48074a14366275511b06debe986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edbd403a98f78d00d44169dfaf4b4a09e96b48074a14366275511b06debe986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9edbd403a98f78d00d44169dfaf4b4a09e96b48074a14366275511b06debe986"
    sha256 cellar: :any_skip_relocation, sonoma:        "9edbd403a98f78d00d44169dfaf4b4a09e96b48074a14366275511b06debe986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230134ecdad90ccadceee0c6b786bc0dc4fab1b3e45cdac691f25217fa2d10af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230134ecdad90ccadceee0c6b786bc0dc4fab1b3e45cdac691f25217fa2d10af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end
