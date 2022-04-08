require 'timetwister'
require 'nypl_ruby_util'

def init
    $logger = NYPLRubyUtil::NyplLogFormatter.new($stdout, level: ENV['LOG_LEVEL'])
    $logger.debug 'Initialized'
end

# rubocop:disable Lint/UnusedMethodArgument
def handle_event(event:, context:)
    init

    begin
        parse_dates event
    rescue JSON::ParserError => e
        create_response(400, { error_message: e.message })
    rescue StandardError => e
        create_response(500, { error_message: e.message })
    end
end
# rubocop:enable Lint/UnusedMethodArgument

def parse_dates(event)
    return create_response(400, { message: 'Request must have body' }) unless event['body']

    dates = JSON.parse(event['body'])['dates']
    if !dates || !(dates.is_a? Array) || !(dates.all? { |date| date.is_a? String })
        return create_response(400, { message: 'Request must have array of dates as strings' })
    end

    parsed_dates = dates.map { |date| [date, Timetwister.parse(date)] }.to_h

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
