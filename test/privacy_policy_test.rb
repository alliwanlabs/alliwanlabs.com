# Checks that every third-party host a page loads resources from is named in
# the privacy policy. Navigation links do not count: only resources the browser
# fetches on its own (stylesheets, @import, url(), scripts, images, iframes).
#
# Run: ruby test/privacy_policy_test.rb
require "minitest/autorun"
require "uri"

class PrivacyPolicyTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  # Third-party host => the provider name the policy must mention.
  PROVIDERS = {
    "fonts.googleapis.com" => "Google",
    "fonts.gstatic.com" => "Google"
  }.freeze

  # Hosts the site itself owns, or that the policy names already.
  FIRST_PARTY = /\A([a-z0-9-]+\.)*alliwanlabs\.com\z/

  RESOURCE_PATTERNS = [
    /@import\s+url\(\s*['"]?(https?:\/\/[^'")\s]+)/i,
    /@import\s+['"](https?:\/\/[^'"]+)/i,
    /url\(\s*['"]?(https?:\/\/[^'")\s]+)/i,
    /<link\b[^>]*\bhref=["'](https?:\/\/[^"']+)/i,
    /<(?:script|img|iframe|source|video|audio)\b[^>]*\bsrc=["'](https?:\/\/[^"']+)/i
  ].freeze

  def source_files
    Dir.glob(File.join(ROOT, "**", "*.{html,css,md}"))
       .reject { |f| f.include?("/_site/") || f.include?("/.jekyll-cache/") || f.include?("/test/") }
  end

  def loaded_hosts
    source_files.flat_map do |file|
      text = File.read(file)
      RESOURCE_PATTERNS.flat_map { |re| text.scan(re).flatten }
                       .map { |url| URI(url).host rescue nil }
                       .compact
                       .map { |host| [host, file.sub("#{ROOT}/", "")] }
    end.reject { |host, _| host.match?(FIRST_PARTY) }
  end

  def test_every_loaded_third_party_host_is_named_in_the_privacy_policy
    policy = File.read(File.join(ROOT, "privacy.md"))
    missing = loaded_hosts.filter_map do |host, file|
      provider = PROVIDERS[host]
      next "#{host} (from #{file}) has no provider entry in this test" unless provider
      next "#{provider} (#{host}, from #{file}) is not named in privacy.md" unless policy.include?(provider)
    end.uniq
    assert_empty missing
  end
end
