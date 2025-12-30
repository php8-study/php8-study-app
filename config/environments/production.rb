# frozen_string_literal: true

require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.hosts.clear

  config.enable_reloading = false

  config.eager_load = true

  config.consider_all_requests_local = false

  config.action_controller.perform_caching = true

  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.silence_healthcheck_path = "/up"

  config.active_support.report_deprecations = false

  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false

  config.active_record.attributes_for_inspect = [ :id ]

  config.action_view.preload_links_header = false

  config.assume_ssl = true

  cloudflare_ips = %w[
    103.21.244.0/22
    103.22.200.0/22
    103.31.4.0/22
    104.16.0.0/13
    104.24.0.0/14
    108.162.192.0/18
    131.0.72.0/22
    141.101.64.0/18
    162.158.0.0/15
    172.64.0.0/13
    173.245.48.0/20
    188.114.96.0/20
    190.93.240.0/20
    197.234.240.0/22
    198.41.128.0/17
    2400:cb00::/32
    2606:4700::/32
    2803:f800::/32
    2405:b500::/32
    2405:8100::/32
    2a06:98c0::/29
    2c0f:f248::/32
  ]

  config.action_dispatch.trusted_proxies = cloudflare_ips.map { |ip| IPAddr.new(ip) }
end
