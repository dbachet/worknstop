# This file is automatically generated. Do not edit.

if Object.const_defined?('TestFlight') and !UIDevice.currentDevice.model.include?('Simulator')
  NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
  TestFlight.setDeviceIdentifier(UIDevice.currentDevice.uniqueIdentifier)
  TestFlight.takeOff('62426d09-d926-478c-9fb5-cd70684c01fc')
  end)
end
