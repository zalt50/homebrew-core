class Rggen < Formula
  desc "Code generation tool for control and status registers"
  homepage "https://github.com/rggen/rggen"
  license "MIT"

  stable do
    url "https://github.com/rggen/rggen.git",
      tag:      "v0.36.0",
      revision: "cf27c0abf99ab2fd421c1973885265af3e37046e"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        tag:      "v0.14.0",
        revision: "d54d92b4e17c1607947f1b6d108ebd94d80e2686"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        tag:      "v0.6.0",
        revision: "d29d7ae019b9c6832780d519af38b99222956c8d"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        tag:      "v0.13.0",
        revision: "d8872192d78381b416423d0e5c88315d4d6c0578"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1832dc7d93150b2370c91bff81402c5e0381fe46e7a2330c6723c7005c0157b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88986dd86533e818c10e69f7b2d8122bedc26ec4d6b7ee8a960138d814f62e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88986dd86533e818c10e69f7b2d8122bedc26ec4d6b7ee8a960138d814f62e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88986dd86533e818c10e69f7b2d8122bedc26ec4d6b7ee8a960138d814f62e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "25af42103656b6b6282d64836fb625c7ceba42f947e5f63b1c5557ae1c879f79"
    sha256 cellar: :any_skip_relocation, ventura:       "25af42103656b6b6282d64836fb625c7ceba42f947e5f63b1c5557ae1c879f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f55dc1c1b14357296de31c1da3f3e74427430afe0496e2b813c2ddaae7b0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c91a2c2cf06d99dfe6684abe7d49179bd4ff30cc246d2151077e5a72db468601"
  end

  head do
    url "https://github.com/rggen/rggen.git",
      branch: "master"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        branch: "master"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        branch: "master"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        branch: "master"
    end
  end

  # Requires Ruby >= 3.1
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    %w[rggen-verilog rggen-veryl rggen-vhdl].each do |plugin|
      resource(plugin).stage do
        system "gem", "build", "#{plugin}.gemspec"
        system "gem", "install", "#{plugin}-#{resource(plugin).version}.gem"
      end
    end

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    test_file = testpath/"test.toml"
    test_file.write <<~EOF
      [[register_blocks]]
      name      = 'test'
      byte_size = 1
      bus_width = 8
      [[register_blocks.registers]]
      name = 'test_register'
      [[register_blocks.registers.bit_fields]]
      name           = 'test_rw_field'
      bit_assignment = { width = 6 }
      type           = 'rw'
      initial_value  = 0
      [[register_blocks.registers.bit_fields]]
      name           = 'test_res_fieldres'
      bit_assignment = { width = 2 }
      type           = 'reserved'
    EOF

    command = "#{bin}/rggen --plugin rggen-vhdl --plugin rggen-verilog --plugin rggen-veryl --load-only #{test_file}"
    assert_empty shell_output(command).strip
  end
end
