class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/fe/c9/721d76a1a90964141123b7fb2085d0656529b05f131afd61bec6cc108e56/dxpy-0.411.0.tar.gz"
  sha256 "8b995dc8cf69ee23f2810c8552eac46182298e935065a6a143bf4c1ea0ae100a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af50874f64df072a1f70f9c8c4e4517cddf77ddc1bff2741d52f3768a8a7e60f"
    sha256 cellar: :any, arm64_sequoia: "5b2632cac6f8ed685dc11778d9e740b9e8bb08cfd13fd9e4ba14a145f7fecfbe"
    sha256 cellar: :any, arm64_sonoma:  "4c23807e97ba7f4edd2ff2db4d10f8059304f2e05d7b3a3cfbd6caaafa862ae6"
    sha256 cellar: :any, sonoma:        "f2e117dda9c082ad1c644cfc8d4373b03fed6cd183a01f842969c672f190e798"
    sha256 cellar: :any, arm64_linux:   "c344e71ff63cf2253f8a0e34e7fb603f219e95177a9e02c85172b51cca4ff001"
    sha256 cellar: :any, x86_64_linux:  "990dcd4d160dc19f3d78a8144e577c880aca8d1710be1cf9206cc3ddde9e1ef7"
  end

  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "s2n"

  on_macos do
    depends_on "aws-c-compression"
    depends_on "aws-c-sdkutils"
    depends_on "openssl@3"
  end

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi websocket-client]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/bd/38/c9945730e522610c2ebf1b38483f1575226e998ab27e8c553dd33fc64e4b/awscrt-0.36.1.tar.gz"
    sha256 "bd1f86b092b57a9ec1f95138224007946eecdf944df1e08fd99f75b64fe2ad20"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  # Issue ref: https://github.com/dnanexus/dx-toolkit/pull/1530
  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"

    livecheck do
      skip "Skip until new release with v1.9.0+"
    end
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
