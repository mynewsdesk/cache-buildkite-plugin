require "json"

module BuildkiteCache
  ORGANIZATION = ENV.fetch("BUILDKITE_ORGANIZATION_SLUG").freeze
  PIPELINE = ENV.fetch("BUILDKITE_PIPELINE_SLUG").freeze

  def self.parse_configuration(json_string)
    raw_keys_and_paths = JSON.parse(json_string)

    keys_and_paths = {}

    raw_keys_and_paths.each do |raw_key, path|
      key = raw_key.gsub %r({{(.*)}}) do
        filename = $1.strip
        sha1sum_output = `sha1sum #{filename}` # "<checksum> <filename>\n"
        sha1sum_output.split(" ").first
      end
      key = "#{ORGANIZATION}/#{PIPELINE}/#{key}"
      keys_and_paths[key] = path
    end

    keys_and_paths
  end
end
