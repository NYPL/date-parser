require 'timetwister'
require 'cgi'
require 'nypl_ruby_util'


def init
  $logger = NYPLRubyUtil::NyplLogFormatter.new($stdout, level: ENV['LOG_LEVEL'])
  $logger.debug 'Initialized'
end

def handle_event(event:, context:)
  init

  path = event['path']
  if path.include? '/docs'
    return swagger_docs
  end

  begin
    parse_dates event
  rescue StandardError => e
    create_response(500, { error_message: e.message})
  end
end

def parse_dates(event)
  params = event['queryStringParameters']
  dates = CGI.unescape(params['dates'])
  parsed_dates = Timetwister.parse(dates)

  create_response(200, { dates: parsed_dates })
end


def swagger_docs
  swagger_docs = JSON.parse(File.read('./swagger.json'))
  create_response(200, swagger_docs)
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
