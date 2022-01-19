class ServiceResponse
  attr_reader :errors, :payload

  def initialize(success:, errors: nil, payload: nil)
    @success = success
    @errors = errors
    @payload = payload
  end

  def success?
    @success
  end
end
