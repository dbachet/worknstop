class MainViewController < UIViewController

  def loadView
    self.view = UIImageView.alloc.init
  end

  def viewDidLoad
    view.backgroundColor = UIColor.darkGrayColor
    view.image = UIImage.imageNamed('transparent-background.png')

    @up_clock = load_clock
    @bottom_clock = load_clock('red', false)
    view.addSubview(@up_clock)
    view.addSubview(create_circle_mask)
    view.addSubview(@bottom_clock)
    view.addSubview(create_circle_mask(false))
  end

  def load_clock(color='green', up=true)
    clock_view = UIView.alloc.initWithFrame([[60, up ? 40 : 340], [200, 200]])
    clock_view.layer.cornerRadius = 100
    if color == 'green'
      clock_view.backgroundColor = UIColor.colorWithRed(0.345, green: 0.784, blue: 0.31, alpha: 1)
    else
      clock_view.backgroundColor = UIColor.colorWithRed(0.929, green: 0.231, blue: 0.431, alpha: 1)
    end
    clock_view
  end

  def create_circle_mask(up=true)
    circle_mask = UIView.alloc.initWithFrame([[70, up ? 50 : 350], [180, 180]])
    circle_mask.layer.cornerRadius = 90
    circle_mask.backgroundColor = UIColor.darkGrayColor
    circle_mask
  end
end