module CrowdRest
  class User

    def self.group_direct(username)
      options = {
        :query => {
          :username => username
        }
      }
      response = CrowdRest.get("/user/group/direct", options)
      normalize_response(response) do |successful_response|
        successful_response.groups = response['groups']
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
