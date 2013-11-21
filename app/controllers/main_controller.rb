class MainController < UIViewController

  def viewDidLoad
    super
    timer_view_dimensions      = [view.frame.size.width, view.frame.size.height/2]
    top_clock_center           = [view.frame.size.width.to_f / 2, view.frame.size.height.to_f / 4]
    top_clock_color            = BubbleWrap.rgb_color(88, 200, 79)
    bottom_clock_center        = [view.frame.size.width.to_f / 2, (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color         = BubbleWrap.rgb_color(237, 59, 110)
    top_time_request_in_min    = App::Persistence['top_timer'] || 25
    bottom_time_request_in_min = App::Persistence['bottom_timer'] || 5

    load_background
    @top_timer  = TimerView.alloc.initWithFrame([[0, 0], timer_view_dimensions], withDelegate: self, withName: 'green', withTime: top_time_request_in_min, withColor: top_clock_color, withCenter: top_clock_center)
    @bottom_timer  = TimerView.alloc.initWithFrame([[0, view.frame.size.height.to_f/2], timer_view_dimensions], withDelegate: self, withName: 'pink', withTime: bottom_time_request_in_min, withColor: bottom_clock_color, withCenter: bottom_clock_center)

    view.addSubview(@top_timer)
    view.addSubview(@bottom_timer)
  end

  def find_timer_view(name)
    if name == 'top'
      @top_timer
    elsif name == 'bottom'
      @bottom_timer
    end
  end

  def timer_views
    [@top_timer, @bottom_timer]
  end

  def load_background
    self.view.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('transparent-background.png'))
  end
end