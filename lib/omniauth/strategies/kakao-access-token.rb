require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class KakaoAccessToken < OmniAuth::Strategies::OAuth2
      option :name, 'kakao_access_token'

      option :client_options, {
        :site => 'https://kauth.kakao.com',
        :authorize_path => '/oauth/authorize',
        :token_url => '/oauth/token',
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_properties['nickname'],
          'image' => raw_properties['thumbnail_image'],
        }
      end

      extra do
        {'properties' => raw_properties}
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.expires? && access_token.refresh_token
        hash.merge!('expires_at' => access_token.expires_at) if access_token.expires?
        hash.merge!('expires' => access_token.expires?)
        hash
      end

      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v1/user/me', {}).parsed || {}
      end
      
      def raw_properties
        @raw_properties ||= raw_info['properties']
      end
      
      def request_phase
        form = OmniAuth::Form.new(:title => "User Token", :url => callback_path)
        form.text_field "Access Token", "access_token"
        form.button "Sign In"
        form.to_response
      end

      def callback_phase
        if !request.params['access_token'] || request.params['access_token'].to_s.empty?
          raise ArgumentError.new("No access token provided.")
        end

        self.access_token = build_access_token
        self.access_token = self.access_token.refresh! if self.access_token.expired?
        
        hash = auth_hash
        hash[:provider] = "kakao"
        self.env['omniauth.auth'] = hash
        call_app!

       rescue ::OAuth::Error => e
         fail!(:invalid_credentials, e)
       rescue ::MultiJson::DecodeError => e
         fail!(:invalid_response, e)
       rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
         fail!(:timeout, e)
       rescue ::SocketError => e
         fail!(:failed_to_connect, e)
      end

      protected

      def build_access_token
        hash = request.params.slice("access_token", "expires_at", "expires", "refresh_token")
        ::OAuth2::AccessToken.from_hash(
          client,
          hash
        )
      end
    end
  end
end
