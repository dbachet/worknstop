class WorkClockViewController < ClockViewController
  def viewDidLoad
    super
    color = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    position =
      [self.view.frame.size.width / 2,
       self.view.frame.size.height / 4]

    @clock = load_clock(color, position)
    self.view.addSubview(@clock)
    self.view.addSubview(empty_circle(position))
  end
end