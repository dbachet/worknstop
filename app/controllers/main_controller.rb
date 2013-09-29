class MainController < UIViewController

  def viewDidLoad
    super
    @background = load_background
    @up_clock = load_clock
    @unfill_up_clock = unfill_circle
    @bottom_clock = load_clock
    @unfill_bottom_clock = unfill_circle

    self.view.addSubview(@background)
    self.view.addSubview(@up_clock)
    view.addSubview(@unfill_up_clock)
    view.addSubview(@bottom_clock)
    view.addSubview(@unfill_bottom_clock)
  end

  def load_clock
    clock_view = UIView.alloc.initWithFrame([[0, 0], [200, 200]])
    clock_view.layer.cornerRadius = 100
    clock_view.center =
      [self.view.frame.size.width / 2,
       self.view.frame.size.height / (@up_clock ? (4.to_f/3) : 4)]
    if @up_clock
      clock_view.backgroundColor = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    else
      clock_view.backgroundColor = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)
    end
    clock_view
  end

  def unfill_circle
    mask = UIView.alloc.initWithFrame([[0, 0], [180, 180]])
    mask.layer.cornerRadius = 90
    mask.center =
      [self.view.frame.size.width / 2,
       self.view.frame.size.height / (@unfill_up_clock ? (4.to_f/3) : 4)]
    mask.backgroundColor = UIColor.darkGrayColor
    mask
  end

  def load_background
    background = UIImageView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    background.image = UIImage.imageNamed('transparent-background.png')
    background.backgroundColor = UIColor.darkGrayColor
    background
  end
end