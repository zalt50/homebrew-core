class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.1.13.tar.gz"
  sha256 "c814c9b2e6c92e08d3db929792c56e2863a1a0e252c774ec048095efea6b67a1"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f55227c8a54fa0e1fb82570a1483f9ad776a7c2e4ad5151c566b0ab1c50b97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f55227c8a54fa0e1fb82570a1483f9ad776a7c2e4ad5151c566b0ab1c50b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f55227c8a54fa0e1fb82570a1483f9ad776a7c2e4ad5151c566b0ab1c50b97"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06db16f260e583b0097607387d21224392ad2537592d299a752c98be707a47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e5f66ef3b327dd509dcfe2a9b8e6b798ef3dc4c02a7d40532e345d3dded39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7dc0580e678b32caea42495cada5241b9a7b10d1f1cb887b3e806fe996ee471"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601050204/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260113123549/dlc.dat"
    sha256 "6ef1e466e7f672a3c49dcd1378b96c8bf38334024252d4a00b1e725df389558d"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.42.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
