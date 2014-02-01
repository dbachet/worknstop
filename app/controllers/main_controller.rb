class MainController < UIViewController

  attr_accessor :background, :timers, :scroll_view, :more_timer_button, :colors
  stylesheet :root

  layout :root do

    self.scroll_view = subview(UIScrollView, :scroll_view) do
      subview(UIImageView, :background)
      2.times.each_with_index do |timer, index|
        build_timer
      end
    end
  end

  def viewDidLayoutSubviews
    super
    set_content_size
    set_timer_center
  end

  def viewDidLoad
    super
    self.title = 'timers.io'

    title = "+"
    add_timer_button = BW::UIBarButtonItem.styled(:plain, title) do
      add_timer
    end
    self.navigationItem.rightBarButtonItem = add_timer_button
  end

  def find_timer_view(name)
    timers.select { |timer| timer.name == name }.first
  end

  private

  def add_timer
    layout(scroll_view) do
      build_timer
    end
    set_content_size
    set_timer_center
    timers.last.draw_timer
  end

  def build_timer
    _timer = TimerView.alloc.initWithFrame([[0, 0], [0, 0]], withDelegate: self,
                                           withName: (nb_timers + 1).to_s, withTime: 5,
                                           withColor: next_color)

    (self.timers ||= []) << subview(_timer, :a_timer)
  end

  def nb_timers
    (self.timers ||= []).size
  end

  def next_color
    self.colors ||= [{r: 245, g: 132, b: 27}, {r: 42, g: 130, b: 197}, {r: 100, g: 51, b: 110}, {r: 23, g: 48, b: 105}, {r: 87, g: 87, b: 92}, {r: 224, g: 113, b: 123}, {r: 69, g: 125, b: 36}, {r: 145, g: 78, b: 27} ]

    _color      = colors[nb_timers]
    self.colors << _color

    color = BubbleWrap.rgb_color(_color[:r], _color[:g], _color[:b])
  end

  def set_content_size
    scroll_view.contentSize = [self.view.frame.size.width, timers.size * timer_height]
  end

  def set_timer_center
    timers.each_with_index do |timer, index|
      if index == 0
        timer.center = [center_x, first_timer_center_y]
      else
        timer.center = [center_x, ((first_timer_center_y + timer_height * (index)))]
      end

      puts "timer nr. #{index}  - Center: #{timer.center.x} - #{timer.center.y}"
    end
  end

  def timer_height
    scroll_view.viewsWithStylename(:a_timer)[0].size.height
  end

  def first_timer_center_y
    self.view.frame.size.height / 4 - 16
  end

  def center_x
    scroll_view.center.x
  end
end