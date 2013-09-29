class MainController < UIViewController
  def viewDidLoad
    super
    @background = load_background
    @work_clock_vc = WorkClockViewController.alloc
    @break_clock_vc = BreakClockViewController.alloc.init

    self.addChildViewController(@work_clock_vc)
    self.addChildViewController(@break_clock_vc)

    self.view.addSubview(@background)

    [@work_clock_vc, @break_clock_vc].each do |vc|
      vc.view.subviews.each do |clock_view|
        self.view.addSubview(clock_view)
      end
    end
  end

  def load_background
    background = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end
end