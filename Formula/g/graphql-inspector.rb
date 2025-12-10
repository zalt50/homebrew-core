class GraphqlInspector < Formula
  desc "Validate schema, get schema change notifications, validate operations, and more"
  homepage "https://the-guild.dev/graphql/inspector"
  url "https://registry.npmjs.org/@graphql-inspector/cli/-/cli-6.0.4.tgz"
  sha256 "cf2b1be0683bf77dd3f74ba5cc7859345f99205c14a02ca3e44e9958957062ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90370edebc092f67b1bf74e22c204534e6532c4d51073d4084c3ee38850132cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"oldSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
      }
    GRAPHQL

    (testpath/"newSchema.graphql").write <<~GRAPHQL
      type Query {
        hello: String
        world: String
      }
    GRAPHQL

    diff_output = shell_output("#{bin}/graphql-inspector diff oldSchema.graphql newSchema.graphql")
    assert_match "Field world was added to object type Query", diff_output
    assert_match "No breaking changes detected", diff_output

    system bin/"graphql-inspector", "introspect", "oldSchema.graphql"
    assert_path_exists "graphql.schema.json"
  end
end
