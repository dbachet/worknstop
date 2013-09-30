class MainController < UIViewController
  def loadView
    self.view = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def viewDidLoad
    super
    view.image = UIImage.imageNamed('transparent-background.png')
    view.backgroundColor = UIColor.darkGrayColor
    top_clock_position =
      [view.frame.size.width / 2,
       view.frame.size.height / 4]
    top_clock_color = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    bottom_clock_position =
      [view.frame.size.width / 2,
       (view.frame.size.height.to_f / 4) * 3]
    bottom_clock_color = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)

    @top_colored_circle = load_colored_circle(top_clock_color, top_clock_position)
    @top_filling_circle = load_filling_circle(top_clock_position)
    @top_countdown_label = load_countdown_label(top_clock_position, '25')
    @bottom_colored_circle = load_colored_circle(bottom_clock_color, bottom_clock_position)
    @bottom_filling_circle = load_filling_circle(bottom_clock_position)
    @bottom_countdown_label = load_countdown_label(bottom_clock_position, '5')

    view.addSubview(@background)
    view.addSubview(@top_colored_circle)
    view.addSubview(@top_filling_circle)
    view.addSubview(@top_countdown_label)
    view.addSubview(@bottom_colored_circle)
    view.addSubview(@bottom_filling_circle)
    view.addSubview(@bottom_countdown_label)

    view.when_tapped do
      start_top_timer
    end
  end

  def start_top_timer

    if !@top_timer
      # App.alert("Let's start timer!")
      @top_timer = Timer.new(@top_countdown_label.text.to_i)
      @top_timer.start
    elsif @top_timer.running?
      # App.alert("Timer stopped!")
      @top_timer.stop
      update_label
    elsif @top_timer.stopped?
      # App.alert("Let's RE-start timer!")
      @top_timer.start
    end

    #TODO set only if not already set
    set_async_label_refresh
  end

  def set_async_label_refresh
    timer = NSTimer.timerWithTimeInterval(1.0, target: self, selector: 'update_label', userInfo: nil, repeats: true)
    NSRunLoop.mainRunLoop.addTimer(timer, forMode: NSRunLoopCommonModes)
  end

  def update_label
    @top_countdown_label.text = @top_timer.remaining_time
  end

  def load_countdown_label(position, default_time)
    countdown_label = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    countdown_label.center = position
    countdown_label.text = default_time
    countdown_label.textAlignment = UITextAlignmentCenter
    countdown_label.textColor = UIColor.whiteColor
    countdown_label
  end

  def load_colored_circle(color, position)
    colored_circle = UIView.alloc.initWithFrame([[0, 0], [200, 200]])
    colored_circle.layer.cornerRadius = 100
    colored_circle.center = position
    colored_circle.backgroundColor = color
    colored_circle
  end

  def load_filling_circle(position)
    filling_circle = UIView.alloc.initWithFrame([[0, 0], [180, 180]])
    filling_circle.layer.cornerRadius = 90
    filling_circle.center = position
    filling_circle.backgroundColor = UIColor.darkGrayColor
    filling_circle
  end
end