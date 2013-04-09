require 'rubygems'

Gem::Specification.new do |s|
  s.name        = 'pg_runner'
  s.version     = '0.1.0'
  s.date        = '2013-04-09'
  s.summary     = "providing database connection pool and easy sql executer for postgresql"
  s.description = "providing database connection pool and easy sql executer for postgresql"
  s.authors     = ["abh0518"]
  s.email       = 'abh0518@gmail.com'
  #s.bindir      = 'bin'
  #s.executables = ['usage_collector']
  s.files       = Dir.glob("**/**/**")
  s.homepage    = 'http://abh0518.net/tok'
end
