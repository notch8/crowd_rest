module CrowdRest
  class Session
    def self.create(username, password)
      body = {
        :username => username,
        :password => password
      }.to_json

      response = CrowdRest.post("/session", :body => body)
      normalize_response(response, 201) do |successful_response|
        successful_response.token = response['token']
      end
    end

    def self.find(token)
      path = "/session/#{token}"
      response = CrowdRest.get(path)
      normalize_response(response) do |successful_response|
        successful_response.user = response['user']
      end
    end

    # extends existing token
    def self.validate(token, options = {})
      body = {}

      validation_factors = options[:validation_factors]
      body['validation-factors'] = validation_factors if validation_factors

      path = "/session/#{token}"
      response = CrowdRest.post(path, :body => body.to_json)
      normalize_response(response) do |successful_response|
        successful_response.user = response['user']
      end
    end

    private
    def self.normalize_response(response, success_code = 200)
      attributes = {
        :code => response.code,
        :body => response.body,
        :reason => response['error'] ? response['error']['reason'] : response['reason'] || nil,
        :message => response['error'] ? response['error']['message'] : response['message'] || nil
      }

      norm_response = OpenStruct.new(attributes)
      yield(norm_response) if block_given? && response.code == success_code
      norm_response
    end
  end
end
