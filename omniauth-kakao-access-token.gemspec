# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-kakao-access-token/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Seok Heo"]
  gem.email         = ["heoseok87@leevi.co.kr"]
  gem.description   = %q{A kakao strategy using token for OmniAuth. Can be used for client side kakao login. }
  gem.summary       = %q{A kakao strategy using token for OmniAuth.}
  
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "omniauth-kakao-access-token"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::KakaoAccessToken::VERSION
  
  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.1'
end