describe Timer do
  before do
    @subject = Timer.new(requested_time_in_min: 25, name: 'top')
  end

  describe '#initialize' do
    it 'should assign @requested_time_in_min' do
      @subject.requested_time_in_min.should == 25
    end

    it 'should assign @name' do
      @subject.name.should == 'top'
    end
  end

  describe '#start' do
    it 'should assign @running to true' do
      @subject.start
      @subject.running.should == true

      @subject.stop # after spec
    end
  end

  describe '#set_alarm' do
    it 'should schedule a local notification' do
      fireDate = Time.now + 1500
      @subject.set_alarm
      notifications = App.shared.scheduledLocalNotifications
      notifications.count.should == 1
      notifications.first.fireDate.to_i.should == fireDate.to_i

      @subject.cancel_notification # after spec
    end
  end

  describe '#running?' do
    it 'should be true' do
      @subject.start
      @subject.running?.should == true

      @subject.stop # after spec
    end
  end

  describe '#stop' do
    it 'should assign @running to false' do
      @subject.start
      @subject.stop
      @subject.running.should == false
    end
  end

  describe '#cancel_notification' do
    it 'should assign @notification to nil and cancel local notification' do
      @subject.start
      @subject.cancel_notification
      @subject.notification.should == nil
      App.shared.scheduledLocalNotifications.should == []
      App.shared.applicationIconBadgeNumber.should == 0
    end
  end

  describe '#stopped?' do
    it 'should be true' do
      @subject.start
      @subject.stop
      @subject.stopped?.should == true
    end
  end

  describe '#remaining_sec' do
    it 'should return a string with remaining seconds' do
      @subject.start
      @subject.remaining_sec.should == 0
      wait 5.0 do
        @subject.remaining_sec.should == 55
      end
      @subject.stop
    end
  end

  describe '#remaining_min' do
    it 'should return a string with remaining min' do
      @subject.start
      @subject.remaining_min.should == 25
      wait 5.0 do
        @subject.remaining_min.should == 24
      end
      @subject.stop
    end
  end
end