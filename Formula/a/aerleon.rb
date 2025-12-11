class Aerleon < Formula
  include Language::Python::Virtualenv

  desc "Generate firewall configs for multiple firewall platforms"
  homepage "https://aerleon.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/07/f7/25b8ed9c98060d0aaf9280bcae867bd1a6189bf2306f6d2d7edb083cb798/aerleon-1.12.1.tar.gz"
  sha256 "78c94c8ac3e5c563e212b647420cb94e3ed5b72a860f5de0b927d2a5500dc82c"
  license "Apache-2.0"
  head "https://github.com/aerleon/aerleon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bd619121aa28922bc80c156af0e2d7bb339ab8e45ac7a88ad7907cecc95e8a8"
    sha256 cellar: :any,                 arm64_sequoia: "b9d3180d7832cd312734e5c77d4de93e8f398939da286d4b7e9b793dd7060522"
    sha256 cellar: :any,                 arm64_sonoma:  "6e2f14b8727215e6ef700b9abb7cde455c8f76819fbd1a5c5726cbb52a234310"
    sha256 cellar: :any,                 sonoma:        "f2ffce8c69f9fce3b2db6facf808d9d578904929a2aa2ae34ff492a0c6891e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bdeb546adeb6444c76d34b7b41f3ca8e478aedffc96e1852e87fbc6a4628a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01c21822707df72e754e5839e00b7c5322a4597da0646768db534e4d573ca10"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "cgrep", because: "both install `cgrep` binaries"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

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
