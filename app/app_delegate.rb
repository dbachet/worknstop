class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.cancelAllLocalNotifications
    resetIconBadge
    Teacup::Appearance.apply

    @window                    = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @mainController            = MainController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@mainController)

    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def application(application, didReceiveLocalNotification:notification)
    if application.applicationState == UIApplicationStateActive
      name = notification.userInfo[:name]
      @mainController.find_timer_view(name).stop_timer

      # Flash / Vibrate
      SystemSounds.play_system_sound('sms-received1.caf')
    end
  end

  def applicationWillEnterForeground(application)
    resetIconBadge

    @mainController.timers.each do |timer_view|
      timer_view.stop_timer if timer_view.timer.notification_has_passed?
    end
  end

  private

  def resetIconBadge
    App.shared.setApplicationIconBadgeNumber(0)
  end
end