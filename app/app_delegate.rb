class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @main_vc = MainController.alloc.initWithNibName(nil, bundle: nil)

    @window.rootViewController = @main_vc
    @window.makeKeyAndVisible
    true
  end
end
