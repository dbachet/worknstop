class Timer
  attr_accessor :starting_time_min, :remaining_sec, :running

  def initialize starting_time_min=25
    @starting_time_min = starting_time_min
    @remaining_sec = starting_time_min * 60
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
      @remaining_sec -= 1
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
    @remaining_sec == 0
  end

  def stop
    stop_run_loop_timer
    @running = false
    @remaining_sec = starting_time_min * 60
  end

  def remaining_time
    min = @remaining_sec / 60
    sec = @remaining_sec - (min * 60)
    "#{min}:#{sec.to_s.rjust(2,'0')}"
  end
end