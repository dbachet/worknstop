class TimerView < UIControl
  attr_accessor :delegate, :timer, :name, :color, :colored_circle, :filling_circle, :label_min, :label_sec, :refresh_label_timer, :needle, :sectors, :current_sector

  def initWithFrame(frame, withDelegate: del, withName: name, withTime: time, withColor: color, withCenter: center)
    if super
      self.delegate     = self
      self.name         = name
      self.timer        = Timer.new(requested_time_in_min: time, name: self.name)
      self.color        = color
      self.center       = center
      self.sectors      = []
      self.current_sector = nil
      self.draw_timer
    end
    self
  end

  def draw_timer
    self.colored_circle   = load_colored_circle(self.color, self.center)
    self.filling_circle   = load_filling_circle
    self.label_min        = load_label_min(self.timer.requested_time_in_min)
    self.label_sec        = load_label_sec
    self.needle           = load_needle

    self.colored_circle.addSubview(self.filling_circle)
    self.colored_circle.addSubview(self.label_min)
    self.colored_circle.addSubview(self.label_sec)


    self.addSubview(self.colored_circle)
    self.addSubview(self.needle)

    build_sectors

    self.rotate_to_sector(self.timer.requested_time_in_min)

    self.filling_circle.when_tapped do
      was_tapped
    end

    self.needle.when_panned do |recognizer|
      if recognizer.state == 1
        stop_timer if self.timer.running?
      elsif recognizer.state == 2
        pt  = recognizer.locationInView(self)
        dx  = pt.x - self.colored_circle.center.x
        dy  = pt.y - self.colored_circle.center.y
        ang = Math.atan2(dy,dx)
        # --------------------------------------
        current_sector = nil
        transform_angle = nil

        self.sectors.each do |s|
          if s.min_value > 0 && s.max_value < 0
            if s.max_value > ang || s.min_value < ang
              if ang > 0
                transform_angle = ang - Math::PI
              else
                transform_angle = Math::PI + ang
              end
              current_sector = s.sector
            end
          elsif ang > s.min_value && ang < s.max_value
            current_sector = s.sector
            transform_angle = ang - s.mid_value
          end
        end

        if !transform_angle.nil?
          self.current_sector = current_sector
          self.rotate_to_sector(current_sector)
          self.label_min.text = current_sector.to_s
        end
      elsif recognizer.state == 3
        update_timer_time_request
        start_timer
        record_time_request
      end
    end
  end

  def find_sector(sector)
    result = nil
    self.sectors.each_with_index do |s, index|
      result = s if s.sector == sector
    end
    result
  end

  def record_time_request
    App::Persistence['time'] = self.timer.requested_time_in_min
  end

  def rotate_to_sector(sector)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.2)
    self.needle.transform = CGAffineTransformMakeRotation(self.find_sector(sector).mid_value+Math::PI+0.1)
    UIView.commitAnimations
  end

  def build_sectors
    number_of_sections = 60
    sections = (1..15).to_a.reverse + (16..60).to_a.reverse

    fan_width = Math::PI * 2 / number_of_sections
    mid       = 0

    number_of_sections.times.each do |i|
      sector           = Sector.new
      sector.mid_value = mid
      sector.min_value = mid - (fan_width / 2)
      sector.max_value = mid + (fan_width / 2)
      sector.sector    = sections[i-1]

      if sector.max_value - fan_width < -Math::PI
        mid = Math::PI
        sector.mid_value = mid;
        sector.min_value = sector.max_value.abs
      end
      mid -= fan_width

      self.sectors << sector
      NSLog("cl is #{sector.inspect}")
    end
  end

  def was_tapped
    if self.timer.running?
      stop_timer
    else
      start_timer
    end
  end

  def start_timer
    self.timer.start
    start_async_label_refresh
  end

  def stop_timer
    self.timer.stop
    stop_async_label_refresh
    reset_labels
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
    rotate_to_sector(self.timer.requested_time_in_min)
  end

  def refresh_labels
    minutes = self.timer.remaining_min
    self.label_min.text = minutes.to_s
    self.label_sec.text = self.timer.remaining_sec.to_s.rjust(2,'0')
    if minutes > 0
      rotate_to_sector(minutes)
    else
      rotate_to_sector(60)
    end
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

  def load_label_min(time)
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [self.colored_circle.bounds.size.width/2, self.colored_circle.bounds.size.height/2]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 34)
    timer_label.text          = time.to_s
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end

  def load_label_sec
    timer_label               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center        = [self.colored_circle.bounds.size.width/2, self.colored_circle.bounds.size.height/2+50]
    timer_label.font          = UIFont.fontWithName('Avenir-Light', size: 17)
    timer_label.text          = 'minutes'
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor     = UIColor.whiteColor
    timer_label
  end

  def load_needle
    # self.needle_container           = UIView.alloc.initWithFrame(self.colored_circle.frame)
    # self.needle_container.backgroundColor = UIColor.blueColor
    angle_size               = 2 * Math::PI / 60

    self.needle                   = UIView.alloc.initWithFrame(CGRectMake(0, 0, 20, 20))
    self.needle.backgroundColor   = UIColor.redColor
    self.needle.layer.anchorPoint = CGPointMake(6, 0.5)
    self.needle.center            = [self.bounds.size.width/2, self.bounds.size.height/2]
    # self.needle.layer.position    = CGPointMake(self.colored_circle.bounds.size.width/2.0, self.colored_circle.bounds.size.height/2.0)
    # self.needle.transform         = CGAffineTransformMakeRotation(angle_size)
    self.needle
  end

  private

  def update_timer_time_request
    self.timer.requested_time_in_min = self.label_min.text.to_i
  end
end