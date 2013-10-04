class MainController < UIViewController
  include TimerHelper

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def viewDidLoad
    super
    top_clock_center_coordinates    = [view.frame.size.width / 2, view.frame.size.height / 4]
    top_clock_color                 = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    bottom_clock_center_coordinates = [view.frame.size.width / 2, (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color              = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)

    @background             = load_background
    @top_colored_circle     = load_colored_circle(top_clock_color, top_clock_center_coordinates)
    @top_filling_circle     = load_filling_circle
    @top_timer_label_min    = load_timer_label_min('25')
    @top_timer_label_sec    = load_timer_label_sec('00')
    @bottom_colored_circle  = load_colored_circle(bottom_clock_color, bottom_clock_center_coordinates)
    @bottom_filling_circle  = load_filling_circle
    @bottom_timer_label_min = load_timer_label_min('5')
    @bottom_timer_label_sec = load_timer_label_sec('00')

    view.addSubview(@background)
    view.addSubview(@top_colored_circle)
    @top_colored_circle.addSubview(@top_filling_circle)
    @top_filling_circle.addSubview(@top_timer_label_min)
    @top_filling_circle.addSubview(@top_timer_label_sec)
    view.addSubview(@bottom_colored_circle)
    @bottom_colored_circle.addSubview(@bottom_filling_circle)
    @bottom_filling_circle.addSubview(@bottom_timer_label_min)
    @bottom_filling_circle.addSubview(@bottom_timer_label_sec)

    @top_filling_circle.when_tapped do
      timer_was_tapped('top')
    end

    @bottom_filling_circle.when_tapped do
      timer_was_tapped('bottom')
    end
  end

  def load_background
    background                 = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image           = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end
end