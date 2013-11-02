class Timer
  attr_accessor :requested_time_in_min, :name, :running, :notification, :alarm_set_at

  def initialize options={}
    raise ArgumentError if options[:name].nil?

    @name                  = options[:name]
    @requested_time_in_min = options[:requested_time_in_min] || 25
  end

  def start
    set_alarm
    self.running = true
  end

  def set_alarm
    self.notification                            = UILocalNotification.alloc.init
    self.notification.soundName                  = UILocalNotificationDefaultSoundName
    self.notification.hasAction                  = true
    self.notification.alertAction                = 'wooohoo'
    self.notification.alertBody                  = "You might have to do something now!"
    self.notification.applicationIconBadgeNumber = 1
    self.notification.userInfo                   = { name: self.name }
    self.notification.fireDate                   = Time.now + (self.requested_time_in_min)
    NSLog("Set notification at #{self.notification.fireDate}")
    App.shared.scheduleLocalNotification(notification)
  end

  def cancel_notification
    NSLog("Cancel notification #{self.notification.userInfo[:name]}")
    App.shared.cancelLocalNotification(self.notification)
    App.shared.setApplicationIconBadgeNumber(0)
  end

  def running?
    self.running == true && !notification_has_passed?
  end

  def stopped?
    !running?
  end

  def stop
    self.running = false
    cancel_notification
  end

  def notification_has_passed?
    self.notification.fireDate < Time.now
  end

  # def ring_bells
  #   SystemSounds.play_system_sound('Glass.aiff')
  # end

  def remaining_min
    ((self.notification.fireDate - Time.now).ceil / 60)
  end

  def remaining_sec
    (self.notification.fireDate - Time.now).ceil % 60
  end
end