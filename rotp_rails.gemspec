$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rotp_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rotp_rails'
  s.version     = RotpRails::VERSION
  s.authors     = ['Barry Allard']
  s.email       = ['barry.allard@gmail.com']
  s.homepage    = 'https://github.com/steakknife/rotp_rails'
  s.summary     = 'ROTP integration for Rails'
  s.description = 'Google Authenticator support for Rails apps'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activesupport'
  s.add_dependency 'railties', '>= 3.1'
  s.add_dependency 'rqrcode'
  s.add_dependency 'rotp'
end
.tap {|gem| pk = File.expand_path(File.join('~/.keys', 'gem-private_key.pem')); gem.signing_key = pk if File.exist? pk; gem.cert_chain = ['gem-public_cert.pem']} # pressed firmly by waxseal
