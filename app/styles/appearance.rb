Teacup::Appearance.new do

  # UINavigationBar.appearance.setBarTintColor(UIColor.blackColor)
  style UINavigationBar,
    barTintColor: BubbleWrap.rgb_color(255, 255, 255),
    titleTextAttributes: {
      UITextAttributeFont => UIFont.fontWithName('HelveticaNeue-UltraLight', size:24),
      UITextAttributeTextColor => UIColor.darkGrayColor
    }
end