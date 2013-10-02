class MainController < UIViewController
  include TimerViews
  attr_accessor :top_timer, :top_timer_label_min, :top_timer_label_sec, :bottom_timer, :bottom_timer_label_min, :bottom_timer_label_sec, :top_ns_timer, :bottom_ns_timer

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def viewDidLoad
    super
    top_clock_center_coordinates =
      [view.frame.size.width / 2,
       view.frame.size.height / 4]
    top_clock_color = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    bottom_clock_center_coordinates =
      [view.frame.size.width / 2,
       (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)

    @background = load_background
    @top_colored_circle = load_colored_circle(top_clock_color, top_clock_center_coordinates)
    @top_filling_circle = load_filling_circle(top_clock_center_coordinates)
    @top_timer_label_min = load_timer_label_min(top_clock_center_coordinates, '25')
    @top_timer_label_sec = load_timer_label_sec(top_clock_center_coordinates, '00')
    @bottom_colored_circle = load_colored_circle(bottom_clock_color, bottom_clock_center_coordinates)
    @bottom_filling_circle = load_filling_circle(bottom_clock_center_coordinates)
    @bottom_timer_label_min = load_timer_label_min(bottom_clock_center_coordinates, '5')
    @bottom_timer_label_sec = load_timer_label_sec(bottom_clock_center_coordinates, '00')

    view.addSubview(@background)
    view.addSubview(@top_colored_circle)
    view.addSubview(@top_filling_circle)
    view.addSubview(@top_timer_label_min)
    view.addSubview(@top_timer_label_sec)
    view.addSubview(@bottom_colored_circle)
    view.addSubview(@bottom_filling_circle)
    view.addSubview(@bottom_timer_label_min)
    view.addSubview(@bottom_timer_label_sec)

    @top_filling_circle.when_tapped do
      start_timer('top')
    end

    @bottom_filling_circle.when_tapped do
      start_timer('bottom')
    end
  end

  def start_timer(position)
    if !get_timer(position)
      set_timer(position, Timer.new(get_timer_label_min(position).text.to_i))
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
      @top_timer_label_min.text = @top_timer.remaining_min.to_s
      @top_timer_label_sec.text = @top_timer.remaining_sec.to_s.rjust(2,'0')
    end
  end

  def refresh_bottom_timer_label
    if @bottom_timer
      @bottom_timer_label_min.text = @bottom_timer.remaining_min.to_s
      @bottom_timer_label_sec.text = @bottom_timer.remaining_sec.to_s.rjust(2,'0')
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

  def get_timer_label_min(position)
    self.send("#{position}_timer_label_min")
  end

  def get_ns_timer(position)
    self.send("#{position}_ns_timer")
  end

  def set_ns_timer(position, val)
    self.send("#{position}_ns_timer=", val)
  end
end