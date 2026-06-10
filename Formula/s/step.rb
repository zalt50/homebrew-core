class Step < Formula
  desc "Crypto and x509 Swiss-Army-Knife"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/cli/releases/download/v0.30.5/step_0.30.5.tar.gz"
  sha256 "2716e59c2380e8008fcb8f1475f0f3ec78593fb762cbafcb51c3d5d206094820"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a054b258c1a51e6089f7fbd5e9f2277e270e9b4e96b7989e49ed149788170b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c2208dcc5c6c98713de35e1812052d4e3d78901e712ba797c224347cbebdab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d034e251baeb2b0ab2fd2cf39be0cf442bf7c13933252dd3f4d567547d456d"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ff144b2b38a4c6cb45609b432c53ad6b3c3ad1a83fcc765f9dd5f3b16c850e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "062abf72405ee7ce82c403ec8786cb02c4bcf5984785339820ef2ef87ccfa1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cebde224af74cc393fef0dc75b85fb0c1f1ac240720cf81650d5aac320f8b7d9"
  end

  depends_on "go" => :build

  # certificates is not always in sync with step, see discussions in https://github.com/smallstep/certificates/issues/1925
  resource "certificates" do
    url "https://github.com/smallstep/certificates/releases/download/v0.30.2/step-ca_0.30.2.tar.gz"
    sha256 "944b205d5ba89f393cbdc09d68ab7ce485f5b44f44c28025d30508af956c1cba"
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?
    ldflags = %W[-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/step"
    generate_completions_from_executable(bin/"step", "completion")

    resource("certificates").stage do |r|
      ldflags = %W[-s -w -X main.Version=#{r.version} -X main.BuildTime=#{time.iso8601}]
      system "go", "build", *std_go_args(ldflags:, output: bin/"step-ca"), "./cmd/step-ca"
    end
  end

  test do
    # Generate a public / private key pair. Creates foo.pub and foo.priv.
    system bin/"step", "crypto", "keypair", "foo.pub", "foo.priv", "--no-password", "--insecure"
    assert_path_exists testpath/"foo.pub"
    assert_path_exists testpath/"foo.priv"

    # Generate a root certificate and private key with subject baz written to baz.crt and baz.key.
    system bin/"step", "certificate", "create", "--profile", "root-ca",
           "--no-password", "--insecure", "baz", "baz.crt", "baz.key"
    assert_path_exists testpath/"baz.crt"
    assert_path_exists testpath/"baz.key"
    baz_crt = (testpath/"baz.crt").read
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, baz_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, baz_crt)
    baz_key = (testpath/"baz.key").read
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, baz_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, baz_key)
    baz_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json baz.crt"))
    assert_equal "CN=baz", baz_crt_json["subject_dn"]
    assert_equal "CN=baz", baz_crt_json["issuer_dn"]

    # Generate a leaf certificate signed by the previously created root.
    system bin/"step", "certificate", "create", "--profile", "intermediate-ca",
           "--no-password", "--insecure", "--ca", "baz.crt", "--ca-key", "baz.key",
           "zap", "zap.crt", "zap.key"
    assert_path_exists testpath/"zap.crt"
    assert_path_exists testpath/"zap.key"
    zap_crt = (testpath/"zap.crt").read
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, zap_crt)
    assert_match(/.*-----END CERTIFICATE-----$/, zap_crt)
    zap_key = (testpath/"zap.key").read
    assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, zap_key)
    assert_match(/.*-----END EC PRIVATE KEY-----$/, zap_key)
    zap_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json zap.crt"))
    assert_equal "CN=zap", zap_crt_json["subject_dn"]
    assert_equal "CN=baz", zap_crt_json["issuer_dn"]

    # Initialize a PKI and step-ca configuration, boot the CA, and create a
    # certificate using the API.
    (testpath/"password.txt").write("password")
    steppath = "#{testpath}/.step"
    mkdir_p(steppath)
    ENV["STEPPATH"] = steppath
    system bin/"step", "ca", "init", "--address", "127.0.0.1:8081",
           "--dns", "127.0.0.1", "--password-file", testpath/"password.txt",
           "--provisioner-password-file", testpath/"password.txt", "--name",
           "homebrew-smallstep-test", "--provisioner", "brew"

    pid = spawn bin/"step-ca", "--password-file", testpath/"password.txt", "#{steppath}/config/ca.json"
    begin
      sleep 6
      assert_match(/^ok$/, shell_output("#{bin}/step ca health"))

      token = shell_output("#{bin}/step ca token --password-file #{testpath}/password.txt homebrew-smallstep-leaf")
      system bin/"step", "ca", "certificate", "--token", token, "homebrew-smallstep-leaf", "brew.crt", "brew.key"

      assert_path_exists testpath/"brew.crt"
      assert_path_exists testpath/"brew.key"
      brew_crt = (testpath/"brew.crt").read
      assert_match(/^-----BEGIN CERTIFICATE-----.*/, brew_crt)
      assert_match(/.*-----END CERTIFICATE-----$/, brew_crt)
      brew_key = (testpath/"brew.key").read
      assert_match(/^-----BEGIN EC PRIVATE KEY-----.*/, brew_key)
      assert_match(/.*-----END EC PRIVATE KEY-----$/, brew_key)
      brew_crt_json = JSON.parse(shell_output("#{bin}/step certificate inspect --format json brew.crt"))
      assert_equal "CN=homebrew-smallstep-leaf", brew_crt_json["subject_dn"]
      assert_equal "O=homebrew-smallstep-test, CN=homebrew-smallstep-test Intermediate CA", brew_crt_json["issuer_dn"]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
