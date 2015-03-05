require 'apoapsis/version'
require 'apoapsis/state'
require 'apoapsis/network'
require 'fileutils'
module Apoapsis
  FileUtils.mkpath '/var/log/apoapsis/' unless File.exists?('/var/log/apoapsis')
  FileUtils.touch('/var/log/apoapsis/apoapsis.log') unless File.exists?('/var/log/apoapsis/apoapsis.log')
  @@logger=Logger.new('/var/log/apoapsis/apoapsis.log',10,1024000)
  @@logger.level=Logger::DEBUG
  # get the apoapsis logger
  def self.log
    @@logger
  end
end
