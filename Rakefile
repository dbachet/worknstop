# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-testflight'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name                   = 'worknstop'
  app.device_family          = [:iphone, :ipad]
  app.version                = '0.1'
  app.codesign_certificate   = "iOS Development: Damien Bachet"
  app.provisioning_profile   = "/Users/le_daf/projects/Apple stuff/Timer_dev_profile.mobileprovision"

  # TestFlight config
  app.testflight.sdk              = 'vendor/TestFlight'
  app.testflight.api_token        = '37f7f997d0385c121ad05cf60551cf5e_MTQxODIxMDIwMTMtMTEtMDMgMTQ6NDE6NDIuNTg5ODMz'
  app.testflight.app_token        = '62426d09-d926-478c-9fb5-cd70684c01fc'
  app.testflight.team_token       = 'a9b3d5ab13d55bd0df43335c3ea07e32_Mjk0ODQwMjAxMy0xMS0wMyAxNDo1MTo0Ny40NzMyODk'
  app.testflight.notify           = true # default is false
  app.testflight.identify_testers = true # default is false
end