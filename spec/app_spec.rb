require_relative 'spec_helper'
require_relative '../app'

ENV['LOG_LEVEL'] = 'error'

describe 'handle_event' do
  it 'should parse a list of dates' do
    sample_event = {
      "path" => "/",
      "body" => "{\"dates\":[\"Jun 3, 1987\",\"Jun 1898 - [July 4 1900]\"]}"
    }

    expect(handle_event(event: sample_event, context: nil)).to eq(
      {
        statusCode: 200,
        body: "{\"dates\":[[{\"original_string\":\"Jun 3, 1987\",\"index_dates\":[1987],\"date_start\":\"1987-06-03\",\"date_end\":\"1987-06-03\",\"date_start_full\":\"1987-06-03\",\"date_end_full\":\"1987-06-03\",\"inclusive_range\":null,\"certainty\":null,\"test_data\":\"200\"}],[{\"original_string\":\"Jun 1898 - [July 4 1900]\",\"index_dates\":[1898,1899,1900],\"date_start\":\"1898-06-01\",\"date_end\":\"1900-07-04\",\"date_start_full\":\"1898-06-01\",\"date_end_full\":\"1900-07-04\",\"inclusive_range\":true,\"certainty\":\"inferred\",\"test_data\":\"330\"}]]}",
        isBase64Encoded: false,
        headers: { 'Content-type': 'application/json' }
      }
    )
  end
end
