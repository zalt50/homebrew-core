class Hotbuild < Formula
  desc "Cross platform hot compilation tool for go"
  homepage "https://hotbuild.rustpub.com/"
  url "https://github.com/wandercn/hotbuild/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "7e8c5c52269344d12d4dc83ae4f472f8aec05faad76379c844dc21c2da44704c"
  license "MulanPSL-2.0"
  head "https://github.com/wandercn/hotbuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ccb806636f0fdd5804757bd8333fce15485f16e5e30c05150a913a71429d065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fbc85999d55d54744d2d91cb460717d72fc448bd5845222218bf3fcf510fd3ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddd19c999dc3804ab7ce881c97e26f62c61579c59ae13aaa3b6d6cfdf8b5bb77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fc5a6d582ee188052e3daa22aa3c6063fb09aaef924deac5cbfe5f697e02f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547bc3bac1e2621f3f6d1dbc83ed412897b2aa1def4a08a5fdbfd2a24e9cde2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0ad321f7a6ab55d11b47e83963984eb51576264653ce4613183a03730f9c7b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f9c67fca7d339796057af29edb1792fbf3058bc1c0dde2d20c8ef0be5fa9f61"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e255bfa37fa3ee34f2c35c5c00ec41879a0c89d17f9073b0dbc215b4be3649"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c61c0aa4d1a3f4beda6764e28af6de0ff60e0fc1df445e52d941daa921a82b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c327c9eddb60305d8b6a5ba1a164ae1ae416f2f448048804f12a42dd07bc8dc"
    sha256 cellar: :any_skip_relocation, catalina:       "32cf72dbf642a44b7a6ad2182fb42946583004a9e87b8a3042f43f918d559c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "366131bed15afecd0f2cb86718a27699414b81ed6a8ac16303ffde07de5a70ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2fa25a273f069d799eb0d30e31b73ca3a8e9fd319c76a6f0171a661fe68ad0"
  end

  depends_on "go" => :build

  # Bump version
  # https://github.com/wandercn/hotbuild/pull/15
  patch do
    url "https://github.com/wandercn/hotbuild/commit/1b04ea4e9e1327ef4d462256072d72f4f37040cb.patch?full_index=1"
    sha256 "b0bbcdf106914307265b4ac81d73667a8b2d4c2fd688cc76dd1e303f690b4021"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = "buildcmd = \"go build -o tmp/tmp_bin\""
    system bin/"hotbuild", "initconf"
    assert_match output, (testpath/".hotbuild.toml").read

    assert_match version.to_s, shell_output("#{bin}/hotbuild version")
  end
end
