class MainController < UIViewController

  attr_accessor :background, :timers, :scroll_view, :more_timer_button
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
                                           withColor: BubbleWrap.rgb_color(88, 200, 79))

    (self.timers ||= []) << subview(_timer, :a_timer)
  end

  def nb_timers
    (self.timers ||= []).size
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