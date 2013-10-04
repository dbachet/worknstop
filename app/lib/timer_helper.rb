module TimerHelper
  extend MotionSupport::Concern

  included do
    attr_accessor :top_timer, :top_timer_label_min, :top_timer_label_sec, :bottom_timer, :bottom_timer_label_min, :bottom_timer_label_sec, :top_ns_timer, :bottom_ns_timer
  end

  def timer_was_tapped(position)
    if timer_is_not_running?(position)
      launch_timer(position)
      set_async_timer_label_refresh(position)
    else
      stop_timer(position)
    end
  end

  def timer_is_not_running?(position)
    if timer_has_been_initialized?(position)
      get_timer_var(position).stopped?
    else
      true
    end
  end

  def stop_timer(position)
    get_timer_var(position).stop
    reset_timer_label(position)
    if position == 'top'
      App.window.rootViewController.top_ns_timer.invalidate
    end

    if position == 'bottom'
      App.window.rootViewController.bottom_ns_timer.invalidate
    end
  end

  def reset_timer_label(position)
    get_timer_label_min_var(position).text = get_timer_var(position).requested_time_in_min.to_s
    get_timer_label_sec_var(position).text = '00'
  end

  def stop_refresh(position)
    get_ns_timer(position).invalidate
  end

  def timer_has_been_initialized?(position)
    get_timer_var(position)
  end

  def init_timer(position)
    set_timer_var(position, load_new_timer(position))
  end

  def start_timer(position)
    get_timer_var(position).start
  end

  def launch_timer(position)
    unless timer_has_been_initialized?(position)
      init_timer(position)
    end
    start_timer(position)
  end

  def load_new_timer(position)
    Timer.new(requested_time_in_min: get_timer_label_min_var(position).text.to_i, position: position)
  end

  # TODO use only one action for the timer / use userInfo
  def set_async_timer_label_refresh(position)
    set_ns_timer(position, NSTimer.timerWithTimeInterval(1.0, target: self, selector: "refresh_#{position}_timer_label", userInfo: nil, repeats: true))
    NSRunLoop.mainRunLoop.addTimer(get_ns_timer(position), forMode: NSRunLoopCommonModes)
  end

  def refresh_top_timer_label
    if @top_timer
      @top_timer_label_min.text = @top_timer.remaining_min.to_i.to_s
      @top_timer_label_sec.text = @top_timer.remaining_sec.to_s.rjust(2,'0')
    end
  end

  def refresh_bottom_timer_label
    if @bottom_timer
      @bottom_timer_label_min.text = @bottom_timer.remaining_min.to_i.to_s
      @bottom_timer_label_sec.text = @bottom_timer.remaining_sec.to_s.rjust(2,'0')
    end
  end

  def load_timer_label_min(default_time)
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [180/2, 180/2]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 34)
    timer_label.text          = default_time
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end

  def load_timer_label_sec(default_time)
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [180/2,(180/2)+50]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 17)
    timer_label.text          = default_time
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end

  def load_colored_circle(color, center_coordinates)
    colored_circle                    = UIView.alloc.initWithFrame([[0, 0], [200, 200]])
    colored_circle.layer.cornerRadius = 100
    colored_circle.center             = center_coordinates
    colored_circle.backgroundColor    = color
    colored_circle
  end

  def load_filling_circle
    filling_circle                    = UIView.alloc.initWithFrame([[10, 10], [180, 180]])
    filling_circle.layer.cornerRadius = 90
    filling_circle.backgroundColor    = UIColor.darkGrayColor
    filling_circle
  end

  private

  def get_timer_var(position)
    self.send("#{position}_timer")
  end

  def set_timer_var(position, val)
    self.send("#{position}_timer=", val)
  end

  def get_timer_label_min_var(position)
    self.send("#{position}_timer_label_min")
  end

  def get_timer_label_sec_var(position)
    self.send("#{position}_timer_label_sec")
  end

  def get_ns_timer(position)
    self.send("#{position}_ns_timer")
  end

  def set_ns_timer(position, val)
    self.send("#{position}_ns_timer=", val)
  end
end