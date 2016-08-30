module CrowdRest
  class Group
    def self.add_user(group, user)
      response = CrowdRest.post("/user/group/direct?username=#{CGI.escape(user)}", body: {name: group}.to_json, content_type: :json, accept: :json)
      normalize_response(response, 201)
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

