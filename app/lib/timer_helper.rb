module TimerHelper
  extend MotionSupport::Concern

  included do
    attr_accessor :top_timer, :top_timer_label_min, :top_timer_label_sec, :bottom_timer, :bottom_timer_label_min, :bottom_timer_label_sec, :top_ns_timer, :bottom_ns_timer
  end

  def load_timer_label_min(center_coordinates, default_time)
    timer_label = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center = center_coordinates
    timer_label.font = UIFont.fontWithName('Avenir-Light', size: 34)
    timer_label.text = default_time
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor = UIColor.whiteColor
    timer_label
  end

  def load_timer_label_sec(center_coordinates, default_time)
    timer_label = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    center_coordinates = [center_coordinates[0], center_coordinates[1] + 50]
    timer_label.center = center_coordinates
    timer_label.font = UIFont.fontWithName('Avenir-Light', size: 17)
    timer_label.text = default_time
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor = UIColor.whiteColor
    timer_label
  end

  def load_colored_circle(color, center_coordinates)
    colored_circle = UIView.alloc.initWithFrame([[0, 0], [200, 200]])
    colored_circle.layer.cornerRadius = 100
    colored_circle.center = center_coordinates
    colored_circle.backgroundColor = color
    colored_circle
  end

  def load_filling_circle(center_coordinates)
    filling_circle = UIView.alloc.initWithFrame([[0, 0], [180, 180]])
    filling_circle.layer.cornerRadius = 90
    filling_circle.center = center_coordinates
    filling_circle.backgroundColor = UIColor.darkGrayColor
    filling_circle
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