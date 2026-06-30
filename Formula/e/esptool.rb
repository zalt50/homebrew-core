class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/76/ac/d2016cf6b3709d0e0166f45f84bc6e2d717757b5f59020ccb34de08d1b9b/esptool-5.3.1.tar.gz"
  sha256 "125781f36e6a2d08c484524a45f340694675368b5eeead9d0cb21b2034a91d98"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f9492ff25b0aac73628c42738a1bf173aa0337a922f0bc18a8c4bb6bbafb39dd"
    sha256 cellar: :any, arm64_sequoia: "0f137591be78f8047214a79b4e8411101164fd711e327dcd2060fba48a06a5f7"
    sha256 cellar: :any, arm64_sonoma:  "a15d98ae5784a8cd2abccca05ba80f825e474dd68146e0cec9acbc93d79d6521"
    sha256 cellar: :any, sonoma:        "e8f0551702320dcc3d1988019e28955fe4ef68c639f8cdb507ed742b9d597367"
    sha256 cellar: :any, arm64_linux:   "0d4fa28265eb2c7c58008132593f534b2bc1ff47e634e87ab44014f5e92378ac"
    sha256 cellar: :any, x86_64_linux:  "a677fbb67c5f3a9d18ac835094e71e0344b301392d36ca6f495be59ac89aa98e"
  end

  depends_on "rust" => :build # for tibs
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/bb/9b/ca307b554eaa233d004cae07d5594f9d45affd1f8e118687059aa06fcc6b/bitarray-3.8.2.tar.gz"
    sha256 "2675a0c17c0b2d12d0fbcf3b27eb833f96936a588da47ac445c0743c5aa69e6b"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/36/d3/de6fe4e7065df8c2f1ac1766f5fdccbe75bc18af2cf2dbeecd34d68e1518/bitstring-4.4.0.tar.gz"
    sha256 "e682ac522bb63e041d16cbc9d0ca86a4f00194db16d0847c7efe066f836b2e37"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/f7/ea/21e4867ea0ef881ffd4c0550fc21a061435e50d6324bcd034396633cbc18/rich_click-1.9.8.tar.gz"
    sha256 "4008f921da88b5d91646c134ec881c1500e5a6b3f093e90e8f29400e09608371"
  end

  resource "tibs" do
    url "https://files.pythonhosted.org/packages/57/cd/6cf028decf1c2df4d26077dd5d0532587d93d4917233d5e004133166a940/tibs-0.5.7.tar.gz"
    sha256 "173dfbecb2309edd9771f453580c88cf251e775613461566b23dbd756b3d54cb"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"esptool", shell_parameter_format: :click)
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "Usage: espefuse", shell_output("#{bin}/espefuse --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
