require 'timetwister'
require 'nypl_ruby_util'


def init
  $logger = NYPLRubyUtil::NyplLogFormatter.new($stdout, level: ENV['LOG_LEVEL'])
  $logger.debug 'Initialized'
end

def handle_event(event:, context:)
  init

  begin
    parse_dates event
  rescue StandardError => e
    create_response(500, { error_message: e.message})
  end
end

def parse_dates(event)
  dates = JSON.parse(event['body'])['dates']
  parsed_dates = dates.map { |date| { date => Timetwister.parse(date) } }

  create_response(200, { dates: parsed_dates })
end

def create_response(status_code = 200, body = nil)
    $logger.info "Responding with #{status_code}"

    {
        statusCode: status_code,
        body: JSON.dump(body),
        isBase64Encoded: false,
        headers: { 'Content-type': 'application/json' }
    }
end
