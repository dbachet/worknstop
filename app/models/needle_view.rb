class NeedleView < UIView

  attr_accessor :context

  def initWithFrame(frame)
    if super
      # @hue = 0.5
      # self.drawRect
    end
    self
  end

  def drawRect(rect)
    self.context = UIGraphicsGetCurrentContext()
    a_path = CGPathCreateMutable()

    CGContextSetLineWidth(context, 1)

    colorspace = CGColorSpaceCreateDeviceRGB()

    color = UIColor.whiteColor.CGColor

    CGContextSetStrokeColorWithColor(self.context, color)

    CGContextMoveToPoint(self.context, 70.3, 54)
    CGContextAddArcToPoint(self.context, 68.5, 39, 70.3, 24, 128)
    CGContextSetShadow(self.context, CGSizeMake(0, 0), 5);
    CGContextAddLineToPoint(self.context, 47, 39)
    CGContextAddLineToPoint(self.context, 70.3, 54)


    CGContextClosePath(self.context)
    CGContextAddPath(self.context, a_path)
    CGContextSetFillColorWithColor(context, color)
    CGContextFillPath(context)


    # CGContextMoveToPoint(self.context, 70, 54)
    # CGContextAddArcToPoint(self.context, 67, 39, 70, 24, 80)
    # # CGContextAddLineToPoint(self.context, 70, 24)
    # CGContextAddLineToPoint(self.context, 47, 39)
    # CGContextAddLineToPoint(self.context, 70, 54)

    #*************** grid help ***************#

    # color = UIColor.redColor.CGColor
    # CGContextSetStrokeColorWithColor(self.context, color)
    # CGContextMoveToPoint(self.context, 77, 55)
    # CGContextAddLineToPoint(self.context, 0, 55)
    # CGContextMoveToPoint(self.context, 77, 39)
    # CGContextAddLineToPoint(self.context, 0, 39)
    # CGContextMoveToPoint(self.context, 77, 23)
    # CGContextAddLineToPoint(self.context, 0, 23)
    # CGContextMoveToPoint(self.context, 68.5, 77)
    # CGContextAddLineToPoint(self.context, 68.5, 0)

    # CGContextStrokePath(self.context)
    #*************** grid help ***************#
  end
end