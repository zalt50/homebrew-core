class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.0.tgz"
  sha256 "7689f03c11af50caab056ead064e190edc95402defc83b2c4de7073cc2c2472c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d40a0e179b58b5c08a03600afa4cf668df58adacfc62bf3b9fff09ea7bfcfb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fd7fb5842706181579b035cf47c56dd7088a2602384c46853ada30adc399cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17fd7fb5842706181579b035cf47c56dd7088a2602384c46853ada30adc399cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "135d73f26236638729bb78bf5cea1d0c89220be284adc7222837f08b7109c290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44a231dc84c0213720832cb8ec68e764e6dbedcd9980fb3a2fd5d51057134eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44a231dc84c0213720832cb8ec68e764e6dbedcd9980fb3a2fd5d51057134eda"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
