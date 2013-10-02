class Timer
  attr_accessor :starting_time_in_min, :remaining_time_in_sec, :running

  def initialize starting_time_in_min=25
    @starting_time_in_min = starting_time_in_min
    @remaining_time_in_sec = starting_time_in_min * 60
  end

  def start
    @running = true
    async_timer_management
  end

  def async_timer_management
    @ns_timer = NSTimer.timerWithTimeInterval(1.0, target: self, selector: 'decrement_or_exit', userInfo: nil, repeats: true)
    NSRunLoop.mainRunLoop.addTimer(@ns_timer, forMode: NSRunLoopCommonModes)
  end

  def decrement_or_exit
    if running? && !finished?
      @remaining_time_in_sec -= 1
    else
      stop
    end
  end

  def stop_run_loop_timer
    @ns_timer.invalidate
  end

  def running?
    @running == true
  end

  def stopped?
    @running == false
  end

  def finished?
    @remaining_time_in_sec == 0
  end

  def stop
    stop_run_loop_timer
    @running = false
    @remaining_time_in_sec = starting_time_in_min * 60
  end

  def remaining_min
    @remaining_time_in_sec / 60
  end

  def remaining_sec
    @remaining_time_in_sec - (remaining_min * 60)
  end
end