class MainController < UIViewController

  include TimerViews
  attr_accessor :top_timer, :top_timer_label, :bottom_timer, :bottom_timer_label, :top_ns_timer, :bottom_ns_timer

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def viewDidLoad
    super
    top_clock_position =
      [view.frame.size.width / 2,
       view.frame.size.height / 4]
    top_clock_color = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    bottom_clock_position =
      [view.frame.size.width / 2,
       (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)

    @background = load_background
    @top_colored_circle = load_colored_circle(top_clock_color, top_clock_position)
    @top_filling_circle = load_filling_circle(top_clock_position)
    @top_timer_label = load_timer_label(top_clock_position, '25')
    @bottom_colored_circle = load_colored_circle(bottom_clock_color, bottom_clock_position)
    @bottom_filling_circle = load_filling_circle(bottom_clock_position)
    @bottom_timer_label = load_timer_label(bottom_clock_position, '5')

    view.addSubview(@background)
    view.addSubview(@top_colored_circle)
    view.addSubview(@top_filling_circle)
    view.addSubview(@top_timer_label)
    view.addSubview(@bottom_colored_circle)
    view.addSubview(@bottom_filling_circle)
    view.addSubview(@bottom_timer_label)

    @top_filling_circle.when_tapped do
      start_timer('top')
    end

    @bottom_filling_circle.when_tapped do
      start_timer('bottom')
    end
  end

  def start_timer(position)
    if !get_timer(position)
      set_timer(position, Timer.new(get_timer_label(position).text.to_i))
      get_timer(position).start
    elsif get_timer(position).running?
      get_timer(position).stop
      send("refresh_#{position}_timer_label")
    elsif get_timer(position).stopped?
      get_timer(position).start
    end

    #TODO set only if not already set
    set_async_timer_refresh(position)
  end

  def set_async_timer_refresh(position)
    set_ns_timer(position, NSTimer.timerWithTimeInterval(1.0, target: self, selector: "refresh_#{position}_timer_label", userInfo: nil, repeats: true))
    NSRunLoop.mainRunLoop.addTimer(get_ns_timer(position), forMode: NSRunLoopCommonModes)
  end

  def refresh_top_timer_label
    if @top_timer
      @top_timer_label.text = @top_timer.remaining_time
    end
  end

  def refresh_bottom_timer_label
    if @bottom_timer
      @bottom_timer_label.text = @bottom_timer.remaining_time
    end
  end

  def load_background
    background = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end

  private

  def get_timer(position)
    self.send("#{position}_timer")
  end

  def set_timer(position, val)
    self.send("#{position}_timer=", val)
  end

  def get_timer_label(position)
    self.send("#{position}_timer_label")
  end

  def set_timer_label(position, val)
    self.send("#{position}_timer_label=", val)
  end

  def get_ns_timer(position)
    self.send("#{position}_ns_timer")
  end

  def set_ns_timer(position, val)
    self.send("#{position}_ns_timer=", val)
  end
end