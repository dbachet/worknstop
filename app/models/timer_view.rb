class TimerView < UIView
  attr_accessor :delegate, :timer, :name, :color, :colored_circle, :filling_circle, :label_min, :label_sec, :refresh_label_timer, :needle, :sectors, :current_sector, :button, :fan_width

  def initWithFrame(frame, withDelegate: del, withName: name, withTime: time, withColor: color, withCenter: center)
    if super
      self.delegate       = self
      self.name           = name
      self.timer          = Timer.new(requested_time_in_min: time, name: self.name)
      self.color          = color
      self.center         = center
      self.sectors        = []
      self.current_sector = nil
      self.draw_timer
    end
    self
  end

  def draw_timer
    build_colored_circle(self.color, self.center)
    build_needle
    build_button
    build_label_min(self.timer.requested_time_in_min)
    build_label_sec

    # self.colored_circle.addSubview(self.filling_circle)
    self.button.addSubview(self.label_min)
    self.button.addSubview(self.label_sec)

    self.colored_circle.layer.borderWidth = 10.0
    self.colored_circle.layer.borderColor = self.color.CGColor


    self.addSubview(self.colored_circle)
    self.addSubview(self.button)
    self.addSubview(self.needle)

    build_sectors

    self.rotate_to_sector(self.timer.requested_time_in_min)

    self.button.when_tapped do |recognizer|
      point = recognizer.locationInView(self)
      if calculateDistanceFromCenter(point) < 75
        button_was_tapped
      end
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

        if !transform_angle.nil? && !at_edge_sector?(current_sector)
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

  def calculateDistanceFromCenter(point)
    center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
    dx     = point.x - center.x
    dy     = point.y - center.y
    Math.sqrt(dx**2 + dy**2)
  end

  def at_edge_sector?(current_sector)
    (self.current_sector == 60 && current_sector < 30) || (self.current_sector == 1 && current_sector > 30)
  end

  def find_sector(sector)
    result = nil
    self.sectors.each_with_index do |s, index|
      result = s if s.sector == sector
    end
    result
  end

  def record_time_request
    App::Persistence["#{self.name}_timer"] = self.timer.requested_time_in_min
  end

  def rotate_to_sector(sector)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.2)
    self.needle.transform = CGAffineTransformMakeRotation(self.find_sector(sector).mid_value + Math::PI + self.fan_width)
    UIView.commitAnimations
  end

  def build_sectors
    number_of_sections = 60
    sections  = (1..15).to_a.reverse + (16..60).to_a.reverse

    self.fan_width = Math::PI * 2 / number_of_sections
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

  def button_was_tapped
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
    self.refresh_label_timer.invalidate if self.refresh_label_timer
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

  def build_colored_circle(color, center_coordinates)
    self.colored_circle                    = UIView.alloc.initWithFrame([[0,0], [190, 190]])
    self.colored_circle.layer.cornerRadius = 95
    self.colored_circle.center             = [self.frame.size.width/2, self.frame.size.height/2]
  end

  def build_button
    self.button                    = UIView.alloc.initWithFrame([[0, 0], [150, 150]])
    self.button.center             = [self.frame.size.width/2, self.frame.size.height/2]
    self.button.layer.cornerRadius = 75
    self.button.backgroundColor    = UIColor.clearColor
    self.button.alpha              = 1
  end

  def build_label_min(time)
    self.label_min               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    self.label_min.center        = [self.button.bounds.size.width/2, self.button.bounds.size.height/2]
    self.label_min.font          = UIFont.fontWithName('Avenir-Light', size: 34)
    self.label_min.text          = time.to_s
    self.label_min.textAlignment = UITextAlignmentCenter
    self.label_min.textColor     = UIColor.whiteColor
  end

  def build_label_sec
    self.label_sec               = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    self.label_sec.center        = [self.button.bounds.size.width/2, self.button.bounds.size.height/2+50]
    self.label_sec.font          = UIFont.fontWithName('Avenir-Light', size: 17)
    self.label_sec.text          = 'minutes'
    self.label_sec.textAlignment = UITextAlignmentCenter
    self.label_sec.textColor     = UIColor.whiteColor
  end

  # def load_needle
  #   self.needle                   = UIImageView.alloc.initWithFrame(CGRectMake(0, 0, 75, 75))
  #   self.needle.image             = UIImage.imageNamed('needle.png')
  #   self.needle.backgroundColor   = UIColor.clearColor
  #   self.needle.layer.anchorPoint = CGPointMake(2, 0.5)
  #   self.needle.center            = [self.bounds.size.width/2, self.bounds.size.height/2]
  #   self.needle
  # end

  def build_needle
    self.needle                   = NeedleView.alloc.initWithFrame(CGRectMake(0, 0, 77, 77))
    self.needle.backgroundColor   = UIColor.clearColor
    self.needle.layer.anchorPoint = CGPointMake(2, 0.5)
    self.needle.center            = [self.bounds.size.width/2, self.bounds.size.height/2]
  end

  private

  def update_timer_time_request
    self.timer.requested_time_in_min = self.label_min.text.to_i
  end
end