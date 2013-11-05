describe 'MainController' do
  tests MainController

  describe 'Top timer' do
    it 'should start, change labels and stop' do
      top_timer_button = views(UIView)[2]
      tap top_timer_button
      proper_wait 1
      top_timer_button.label_min.text.should == '24'
      top_timer_button.label_sec.text.should == '59'
      tap top_timer_button
      # proper_wait 1
      # top_timer_button.label_min.text.should == '25'
      # top_timer_button.label_sec.text.should == 'minutes'
    end
  end
end
