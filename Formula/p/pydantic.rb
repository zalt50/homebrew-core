class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://pydantic.dev/docs/validation"
  url "https://files.pythonhosted.org/packages/9f/d5/b4867fa7c7f04c34997d7d8aad744f64d210bb99d67cf18bf3fb1eea1aed/pydantic-2.14.2.tar.gz"
  sha256 "fb7b2db6cefe8414dd612edeede49c4c433acb0432b0f92b95024e45f66c505d"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2c2f0cddc55f80ce650282db79c4e5f540abd6518fb7c7d97dfd826b2fa83ef1"
    sha256 cellar: :any, arm64_tahoe:       "004c996ed485a2965d841af3fbc432ec89276b2b663bf4dcec8aeaa8a77d24d3"
    sha256 cellar: :any, arm64_sequoia:     "c8ed4119dd8f86c41abbf466174c0a293c3e1be601d6e912f73e6c27f34c8d53"
    sha256 cellar: :any, arm64_linux:       "36ea152e4ce2e99f38c0440d646a602bf3002ef226cdda4df1e0216dfd7f67b3"
    sha256 cellar: :any, x86_64_linux:      "a469052795a8cd7506a6991da892b3d247c0088ea335fff60dced2c082140023"
  end

  depends_on "maturin" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/8e/23ec1021834e35041fbb2f10946141e6acdfd39379c45cc4d65a4e8a1d98/pydantic_core-2.50.2.tar.gz"
    sha256 "1b0e8dc3932cf4e9ed5727570325cacc716b9409ffc794a221c0ccc72e8eb775"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  allow_network_access! :build

  def install
    pythons.each do |python3|
      resources.each do |r|
        r.stage do
          build_isolation = r.name != "pydantic-core"
          system python3, "-m", "pip", "install", *std_pip_args(build_isolation:), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", <<~PYTHON
        from pydantic import BaseModel, ValidationError

        class Model(BaseModel):
            value: int

        assert Model(value="42").model_dump() == {"value": 42}
        try:
            Model(value="invalid")
        except ValidationError as error:
            assert error.errors()[0]["type"] == "int_parsing"
        else:
            raise AssertionError("Invalid input was accepted")
      PYTHON
    end
  end
end
