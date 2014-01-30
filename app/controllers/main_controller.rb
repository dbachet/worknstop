class MainController < UIViewController

  attr_accessor :background, :timers, :scroll_view, :more_timer_button
  stylesheet :root

  layout :root do

    self.scroll_view = subview(UIScrollView, :scroll_view) do
      subview(UIImageView, :background, frame: UIScreen.mainScreen.bounds)
      2.times.each_with_index do |timer, index|
        build_timer
      end
    end
  end

  def viewDidLayoutSubviews
    super
    set_content_size

    set_timer_center
    timers.each(&:draw_timer)
  end

  def viewDidLoad
    super
    self.title = 'timers.io'

    title = "+"
    add_timer_button = BW::UIBarButtonItem.styled(:plain, title) do
      add_timer
    end
    self.navigationItem.rightBarButtonItem = add_timer_button
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
    self.background                 = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    image                           = UIImage.imageNamed('transparent-background.png')
    self.background.backgroundColor = UIColor.colorWithPatternImage(image)
    self.view.backgroundColor       = UIColor.darkGrayColor
    self.background
  end

  private

  def build_timer
    needle_size = if Device.iphone?
      77
    else
      115.5
    end

    _timer = build_timer_view do |new_timer|
      new_timer.colored_circle = subview(UIView, :colored_circle)
      new_timer.needle         = subview(UIImageView, :needle, frame: [[0,0],[needle_size, needle_size]])
      new_timer.button         = subview(UIView, :button)
      new_timer.label_min      = subview(UILabel, :label_min, text: new_timer.timer.requested_time_in_min.to_s)
      new_timer.label_sec      = subview(UILabel, :label_sec)
    end

    (self.timers ||= []) << _timer
  end

  def build_timer_view
    subview(TimerView, :a_timer,
            backgroundColor: UIColor.grayColor,
            delegate: self,
            name: 'names[index]',
            sectors: [],
            current_sector: nil,
            timer: Timer.new(requested_time_in_min: 5, name: 'names[index]'),
            color: BubbleWrap.rgb_color(88, 200, 79)) do |timer|
      yield timer
    end
  end

  def add_timer
    layout(scroll_view) do
      build_timer
    end
    set_content_size
    set_timer_center
    timers.last.draw_timer
  end

  def set_content_size
    scroll_view.contentSize = [self.view.frame.size.width, timers.size * timer_height]
  end

  def set_timer_center
    timers.each_with_index do |timer, index|
      if index != 0
        timer.center = [center_x, ((first_timer_center_y + timer_height * (index)))]
      else
        timer.center = [center_x, first_timer_center_y]
      end
    end
  end

  def timer_height
    scroll_view.viewsWithStylename(:a_timer)[0].size.height
  end

  def first_timer_center_y
    self.view.frame.size.height / 4 - 16
  end

  def center_x
    scroll_view.center.x
  end
end