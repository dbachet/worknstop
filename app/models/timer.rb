class Timer
  attr_accessor :requested_time_in_min, :running, :notification, :alarm_set_at

  def initialize options={}
    raise ArgumentError if options[:position].nil?

    @position              = options[:position]
    @requested_time_in_min = options[:requested_time_in_min] || 25
  end

  def start
    set_alarm
    @running = true
  end

  def set_alarm
    @alarm_set_at                            = Time.now + (@requested_time_in_min * 1)
    @notification                            = UILocalNotification.alloc.init
    @notification.soundName                  = 'alarm.caf'#UILocalNotificationDefaultSoundName
    @notification.hasAction                  = true
    @notification.alertAction                = 'wooohoo'
    @notification.alertBody                  = "You might have to do something now!"
    @notification.applicationIconBadgeNumber = 1
    @notification.userInfo                   = { position: @position }
    @notification.fireDate                   = @alarm_set_at
    NSLog("Set notification at #{@notification.fireDate}")
    App.shared.scheduleLocalNotification(notification)
  end

  def cancel_notification
    NSLog("cancel notification #{@notification.userInfo[:position]}")
    App.shared.cancelLocalNotification(@notification)
    @notification = nil
    # icon_badge_number = App.shared.applicationIconBadgeNumber
    App.shared.setApplicationIconBadgeNumber(0)
  end

  # def decrement_or_exit
  #   if running? && !finished?
  #     @remaining_time_in_sec -= 1
  #     ring_bells if finished?
  #   else
  #     stop
  #   end
  # end

  def running?
    @running == true
  end

  def stopped?
    @running == false
  end

  # def finished?
  #   @remaining_time_in_sec == 0
  # end

  def stop
    @running = false
    # reset_timer
    cancel_notification
  end

  # def reset_timer
  #   @alarm_set_at = Time.now + (requested_time_in_min * 1)
  # end

  # def ring_bells
  #   SystemSounds.play_system_sound('Glass.aiff')
  # end

  def remaining_min
    ((@alarm_set_at - Time.now) / 60)
  end

  def remaining_sec
    ((@alarm_set_at - Time.now) - (remaining_min.to_i * 60)).ceil
  end
end