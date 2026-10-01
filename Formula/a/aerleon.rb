class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/fb/4c4c1efe07861f45fd6a06e67f9c5756663ff8c72fafda2ebaa7a71d0bd5/aerleon-1.18.0.tar.gz"
  sha256 "dcfcbefd62b39a6412912760b95360f5bd67239b4077f542c9095f36e419e341"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d51d7aa41adb244b7bc3c3cb0cbe399e7e3bf6e50f94abd0980108d3f1d17acf"
    sha256 cellar: :any, arm64_tahoe:       "fa27c7b1c55891f4dc0fc7a7cfef0395a8f10fed362e10c764eb6335ebb58c4c"
    sha256 cellar: :any, arm64_sequoia:     "e5b47a5b21cd6697bf290544505de6d2208504357d708ed419208aadca389e98"
    sha256 cellar: :any, arm64_sonoma:      "1ac6386bfe9e639f3dba8b77b67d8cd98284933e892028451d028b24b11e4af9"
    sha256 cellar: :any, sonoma:            "a1765b10e67da0d4f486bf75b9756db9c149f7d6816f4cc0c3a0e6bad81e059e"
    sha256 cellar: :any, arm64_linux:       "895e7d90e7287c61980c3242040beee1b89d8559767ca501fa7c7d5769361b1a"
    sha256 cellar: :any, x86_64_linux:      "c8212ba221906cc8b01780cd7864abcef807adae420922404aec23f5430fec9e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/d0/4f/d79676ab82f2e42fc3611618139f13a9c4c31d0cff4b486982047679a802/absl_py-2.5.0.tar.gz"
    sha256 "0c996f25c0490700fadabe6351630f6111534fa0ae252cc6d2014ea3b141135f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall]

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"def/definitions.yaml").write <<~YAML
      networks:
        RFC1918:
          values:
            - address: 10.0.0.0/8
            - address: 172.16.0.0/12
            - address: 192.168.0.0/16
        WEB_SERVERS:
          values:
            - address: 10.0.0.1/32
              comment: Web Server 1
            - address: 10.0.0.2/32
              comment: Web Server 2
        MAIL_SERVERS:
          values:
            - address: 10.0.0.3/32
              comment: Mail Server 1
            - address: 10.0.0.4/32
              comment: Mail Server 2
        ALL_SERVERS:
          values:
            - WEB_SERVERS
            - MAIL_SERVERS
      services:
        HTTP:
          - protocol: tcp
            port: 80
        HTTPS:
          - protocol: tcp
            port: 443
        WEB:
          - HTTP
          - HTTPS
        HIGH_PORTS:
          - port: 1024-65535
            protocol: tcp
          - port: 1024-65535
            protocol: udp
    YAML

    (testpath/"policies/pol/example.pol.yaml").write <<~YAML
      filters:
      - header:
          comment: Example inbound
          targets:
            cisco: inbound extended
        terms:
          - name: accept-web-servers
            comment: Accept connections to our web servers.
            destination-address: WEB_SERVERS
            destination-port: WEB
            protocol: tcp
            action: accept
          - name: default-deny
            comment: Deny anything else.
            action: deny#{"  "}
    YAML

    assert_match "writing file: example.pol.acl", shell_output("#{bin}/aclgen 2>&1")
    assert_path_exists "example.pol.acl"
  end
end
