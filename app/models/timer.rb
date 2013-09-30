class Timer
  attr_accessor :starting_time_min, :remaining_sec, :running, :completed

  def initialize starting_time_min=25
    @starting_time_min = starting_time_min
    @remaining_sec = starting_time_min * 60
  end

  def start
    @running = true
    async_decrement
  end

  def async_decrement
    #TODO shouldn't use NSTimer ?
    Dispatch::Queue.concurrent.async do
      @remaining_sec.times.each do |time|
        decrement_or_exit
      end
    end
  end

  def decrement_or_exit
    if running? && !finished?
      sleep(1)
      @remaining_sec -= 1
    else
      stop
      return true
    end
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
    @running = false
    @remaining_sec = starting_time_min * 60
  end

  def remaining_time
    min = @remaining_sec / 60
    sec = @remaining_sec - (min * 60)
    "#{min}:#{sec.to_s.rjust(2,'0')}"
  end
end