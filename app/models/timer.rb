class Timer
  attr_accessor :requested_time_in_min, :name, :running, :notification, :alarm_set_at

  def initialize options={}
    raise ArgumentError if options[:name].nil?

    @name                  = options[:name]
    @requested_time_in_min = options[:requested_time_in_min] || 25
  end

  def start
    set_alarm
    @running = true
  end

  def set_alarm
    @alarm_set_at                            = Time.now + (@requested_time_in_min * 60)
    @notification                            = UILocalNotification.alloc.init
    @notification.soundName                  = 'alarm.caf'#UILocalNotificationDefaultSoundName
    @notification.hasAction                  = true
    @notification.alertAction                = 'wooohoo'
    @notification.alertBody                  = "You might have to do something now!"
    @notification.applicationIconBadgeNumber = 1
    @notification.userInfo                   = { name: @name }
    @notification.fireDate                   = @alarm_set_at
    NSLog("Set notification at #{@notification.fireDate}")
    App.shared.scheduleLocalNotification(notification)
  end

  def cancel_notification
    NSLog("Cancel notification #{@notification.userInfo[:name]}")
    App.shared.cancelLocalNotification(@notification)
    @notification = nil
    App.shared.setApplicationIconBadgeNumber(0)
  end

  def running?
    @running == true
  end

  def stopped?
    !running?
  end

  def stop
    @running = false
    cancel_notification
  end

  # def ring_bells
  #   SystemSounds.play_system_sound('Glass.aiff')
  # end

  def remaining_min
    ((@alarm_set_at - Time.now).ceil / 60)
  end

  def remaining_sec
    (@alarm_set_at - Time.now).ceil % 60
  end
end