class MainController < UIViewController

  def viewDidLoad
    super
    top_clock_center    = [view.frame.size.width / 2, view.frame.size.height / 4]
    top_clock_color                 = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    bottom_clock_center_coordinates = [view.frame.size.width / 2, (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color              = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)

    @background             = load_background
    @top_timer = TimerView.alloc.initWithFrame([[0, 0], [view.frame.size.width, view.frame.size.height/2]], withDelegate: self, withName: 'top', withTime: 25, withColor: top_clock_color, withCenter: top_clock_center)

    view.addSubview(@background)
    view.addSubview(@top_timer)

    # @top_filling_circle.when_tapped do
    #   timer_was_tapped('top')
    # end

    # @bottom_filling_circle.when_tapped do
    #   timer_was_tapped('bottom')
    # end
  end

  def load_background
    background                 = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image           = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end
end