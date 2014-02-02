Teacup::Stylesheet.new :root do
  if device_is? iPhone
    circle_size = 190
    needle_size = 77
    button_size = 150
    label_x, label_y = 100, 30
    label_min_font_size = 34
    label_sec_font_size = 17
    label_offset = 50
    circle_border_width = 10.0
    backgroundImage = UIImage.imageNamed('transparent-background.png')
  elsif device_is? iPad
    circle_size = 285
    needle_size = 115.5
    button_size = 225
    label_x, label_y = 150, 45
    label_min_font_size = 45
    label_sec_font_size = 25
    label_offset = 75
    circle_border_width = 15.0
    backgroundImage = UIImage.imageNamed('transparent-background.png')
  end

  style :root,
    backgroundColor: UIColor.darkGrayColor

  style :background,
    backgroundColor: UIColor.colorWithPatternImage(backgroundImage),
    frame: UIScreen.mainScreen.bounds

  style :scroll_view,
    scrollEnabled: true,
    frame: UIScreen.mainScreen.bounds

  style :a_timer,
    width: '100%',
    height: '50% - 32'

  style :colored_circle,
    width: circle_size,
    height: circle_size,
    center_x: '50%',
    center_y: '50%',
    layer: {
      cornerRadius: circle_size / 2,
      borderWidth: circle_border_width,
    }

  style :needle,
    center_x: '50%',
    center_y: '50%',
    image: UIImage.imageNamed('hand.png'),
    layer: {
      anchorPoint: CGPointMake(2, 0.5)
    }

  style :button,
    width: button_size,
    height: button_size,
    center_x: '50%',
    center_y: '50%',
    backgroundColor: UIColor.clearColor,
    alpha: 1,
    layer: {
      cornerRadius: button_size / 2
    }

  style :label_min,
    width: label_x,
    height: label_y,
    center_x: '50%',
    center_y: '50%',
    font: UIFont.fontWithName('Avenir-Light', size: label_min_font_size),
    textAlignment: UITextAlignmentCenter,
    textColor: UIColor.whiteColor

  style :label_sec,
    width: label_x,
    height: label_y,
    center_x: '50%',
    center_y: "50% + #{label_offset}",
    text: 'minutes',
    font: UIFont.fontWithName('Avenir-Light', size: label_sec_font_size),
    textAlignment: UITextAlignmentCenter,
    textColor: UIColor.whiteColor

  style :label_estimated_time,
    width: label_x,
    height: label_y,
    center_x: '50%',
    center_y: "50% - #{label_offset}",
    font: UIFont.fontWithName('Avenir-Light', size: label_sec_font_size),
    textAlignment: UITextAlignmentCenter,
    textColor: UIColor.whiteColor

  style :shadow,
    layer: {
      shadowOpacity: 0.6,
      shadowColor: BubbleWrap.rgb_color(102, 175, 233).CGColor,
      shadowOffset: [0, 0]
    }

  style :unset_shadow,
    layer: {
      shadowOpacity: 0
    }
end