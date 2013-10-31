class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.cancelAllLocalNotifications
    resetIconBadge
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @main_vc = MainController.alloc.initWithNibName(nil, bundle: nil)

    @window.rootViewController = @main_vc
    @window.makeKeyAndVisible
    true
  end

  def application(application, didReceiveLocalNotification:notification)
    if application.applicationState == UIApplicationStateActive
      name = notification.userInfo[:name]
      @main_vc.find_timer_view(name).stop_timer
      # SystemSounds.play_system_sound(UILocalNotificationDefaultSoundName)
    end
  end

  # def applicationWillEnterForeground(application)
  #   resetIconBadge
  #   top_timer = @window.rootViewController.top_timer
  #   bottom_timer = @window.rootViewController.bottom_timer

  #   if top_timer && top_timer.running?
  #     @main_vc.refresh_top_timer_label

  #     if top_timer.alarm_set_at < Time.now
  #       @main_vc.stop_timer('top')
  #       App.alert("Top timer has finished!")
  #     end
  #   end

  #   if bottom_timer && bottom_timer.running?
  #     @main_vc.refresh_bottom_timer_label

  #     if bottom_timer.alarm_set_at < Time.now
  #       @main_vc.stop_timer('bottom')
  #       App.alert('Bottom timer has finished!')
  #     end
  #   end
  # end

  private

  def resetIconBadge
    App.shared.setApplicationIconBadgeNumber(0)
  end
end