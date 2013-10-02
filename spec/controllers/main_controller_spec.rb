describe 'MainController' do
  tests MainController

  describe 'Top Timer' do
    it 'It should start top timer when we tap on it' do
      top_timer_button = views(UIView)[2]

      tap top_timer_button
      proper_wait 3
      top_timer_label_min = views(UILabel)[0]
      top_timer_label_sec = views(UILabel)[1]
      top_timer_label_min.text.should == '24'
      top_timer_label_sec.text.should == '57'
    end

    it 'It should stop top timer when we tap on it a second time and reset it' do
      top_timer_button = views(UIView)[2]

      tap top_timer_button
      proper_wait 3
      tap top_timer_button
      top_timer_label_min = views(UILabel)[0]
      top_timer_label_sec = views(UILabel)[1]
      top_timer_label_min.text.should == '25'
      top_timer_label_sec.text.should == '00'
    end
  end

  describe 'Bottom Timer' do
    it 'It should start bottom timer when we tap on it' do
      bottom_timer_button = views(UIView)[6]

      tap bottom_timer_button
      proper_wait 3
      bottom_timer_label_min = views(UILabel)[2]
      bottom_timer_label_sec = views(UILabel)[3]
      bottom_timer_label_min.text.should == '4'
      bottom_timer_label_sec.text.should == '57'
    end

    it 'It should stop bottom timer when we tap on it a second time and reset it' do
      bottom_timer_button = views(UIView)[6]

      tap bottom_timer_button
      proper_wait 3
      tap bottom_timer_button
      bottom_timer_label_min = views(UILabel)[2]
      bottom_timer_label_sec = views(UILabel)[3]
      bottom_timer_label_min.text.should == '5'
      bottom_timer_label_sec.text.should == '00'
    end
  end
end