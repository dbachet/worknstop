describe Timer do
  before do
    @subject = Timer.new
  end
  describe '#initialize' do

    it 'should assign @starting_time_min' do
      @subject.starting_time_min.should == 25
    end

    it 'should assign @remaining_sec' do
      @subject.remaining_sec.should == 1500
    end
  end

  describe '#start' do
    it 'should assign @running to true' do
      @subject.start
      @subject.running.should == true
      @subject.stop
    end
  end

  describe '#running?' do
    it 'should be true' do
      @subject.start
      @subject.running?.should == true
      @subject.stop
    end
  end

  describe '#stop' do
    it 'should assign @running to true' do
      @subject.start
      @subject.stop
      @subject.running.should == false
      @subject.remaining_sec.should == (@subject.starting_time_min * 60)
    end
  end

  describe '#stopped?' do
    it 'should be true' do
      @subject.start
      @subject.stop
      @subject.stopped?.should == true
    end
  end

  describe '#remaining_time' do
    it 'should return a string with starting time' do
      @subject.start
      @subject.remaining_time.should == '25:00'
      @subject.stop
    end

    it 'should be 5 seconds less than starting time' do
      @subject = Timer.new
      @subject.start
      wait 5.0 do
        @subject.remaining_time.should == '24:56'
        @subject.stop
      end
    end
  end

  describe '#decrement_or_exit' do

    before { @subject.running = true }

    describe 'when should continue to decrement' do

      it 'should decrement @remaining_sec' do
        @subject.decrement_or_exit
        wait 1 do
          @subject.remaining_sec.should == 1499
        end
      end
    end

    describe 'when should continue to decrement' do

      before { @subject.remaining_sec = 0 }

      it 'should decrement @remaining_sec' do
        @subject.decrement_or_exit
        wait 1 do
          @subject.stopped?.should == true
        end
      end
    end
  end

  describe '#finished?' do
    it 'should be completed' do
      @subject = Timer.new(1)
      @subject.start
      wait 62 do
        @subject.remaining_time.should == '0:00'
        @subject.finished?.should == true
      end
    end
  end
end