class TimerView < UIView
  attr_accessor :delegate, :timer, :name, :time_request, :color, :colored_circle, :filling_circle, :label_min, :label_sec, :refresh_label_timer

  def initWithFrame(frame, withDelegate: del, withName: name, withTime: time, withColor: color, withCenter: center)
    if super
      self.delegate     = self
      self.name         = name
      self.time_request = time
      self.timer        = Timer.new(requested_time_in_min: self.time_request, name: self.name)
      self.color        = color
      self.center       = center
      self.draw_timer
    end
    self
  end

  def draw_timer
    self.colored_circle = load_colored_circle(self.color, self.center)
    self.filling_circle = load_filling_circle
    self.label_min      = load_timer_label_min(self.time_request)
    self.label_sec      = load_timer_label_sec

    self.colored_circle.addSubview(self.filling_circle)
    self.colored_circle.addSubview(self.label_min)
    self.colored_circle.addSubview(self.label_sec)

    self.addSubview(self.colored_circle)

    self.filling_circle.when_tapped do
      was_tapped
    end
  end

  def was_tapped
    if self.timer.running?
      self.timer.stop
      stop_async_label_refresh
      reset_labels
    else
      self.timer.start
      start_async_label_refresh
    end
  end

  # TODO use only one action for the timer / use userInfo
  def start_async_label_refresh
    self.refresh_label_timer = NSTimer.timerWithTimeInterval(1.0, target: self, selector: 'refresh_labels', userInfo: nil, repeats: true)
    NSRunLoop.mainRunLoop.addTimer(self.refresh_label_timer, forMode: NSRunLoopCommonModes)
  end

  def stop_async_label_refresh
    self.refresh_label_timer.invalidate
  end

  def reset_labels
    self.label_min.text = self.timer.requested_time_in_min.to_s
    self.label_sec.text = 'minutes'
  end

  def refresh_labels
    self.label_min.text = self.timer.remaining_min.to_s
    self.label_sec.text = self.timer.remaining_sec.to_s
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

  def load_timer_label_min(time)
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [180/2, 180/2]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 34)
    timer_label.text          = time.to_s
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end

  def load_timer_label_sec
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [180/2,(180/2)+50]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 17)
    timer_label.text          = 'minutes'
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end
end