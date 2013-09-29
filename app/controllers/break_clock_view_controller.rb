class BreakClockViewController < ClockViewController
  def viewDidLoad
    super
    color = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)
    position =
      [self.view.frame.size.width / 2,
       (self.view.frame.size.height.to_f / 4) * 3]

    @clock = load_clock(color, position)
    self.view.addSubview(@clock)
    self.view.addSubview(empty_circle(position))
  end
end