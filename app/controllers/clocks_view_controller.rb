class ClockViewController < UIViewController
  def load_clock color, position
    clock_view = UIView.alloc.initWithFrame([[0, 0], [200, 200]])
    clock_view.layer.cornerRadius = 100
    clock_view.center = position
    clock_view.backgroundColor = color
    clock_view
  end

  def empty_circle position
    mask = UIView.alloc.initWithFrame([[0, 0], [180, 180]])
    mask.layer.cornerRadius = 90
    mask.center = position
    mask.backgroundColor = UIColor.darkGrayColor
    mask
  end
end