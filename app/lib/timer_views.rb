module TimerViews
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
end