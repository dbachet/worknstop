class MainController < UIViewController

  def viewDidLoad
    super
    top_clock_center    = [view.frame.size.width / 2, view.frame.size.height / 4]
    top_clock_color     = BubbleWrap.rgb_color(88, 200, 79)
    bottom_clock_center = [view.frame.size.width / 2, (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color  = BubbleWrap.rgb_color(237, 59, 110)
    time_request_in_min = App::Persistence['time'] || 25

    @background = load_background
    @top_timer  = TimerView.alloc.initWithFrame([[0, 0], [view.frame.size.width, view.frame.size.height/2]], withDelegate: self, withName: 'top', withTime: time_request_in_min, withColor: top_clock_color, withCenter: top_clock_center)

    view.addSubview(@background)
    view.addSubview(@top_timer)
  end

  def find_timer_view(name)
    if name == 'top'
      @top_timer
    elsif name == 'bottom'
      @bottom_timer
    end
  end

  def load_background
    background                 = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image           = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end
end