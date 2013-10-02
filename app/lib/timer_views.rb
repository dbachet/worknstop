module TimerViews
  def load_timer_label(position, default_time)
    timer_label = UILabel.alloc.initWithFrame([[0,0], [100, 30]])
    timer_label.center = position
    timer_label.text = default_time
    timer_label.textAlignment = UITextAlignmentCenter
    timer_label.textColor = UIColor.whiteColor
    timer_label
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