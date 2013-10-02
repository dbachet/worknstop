describe 'MainController' do
  tests MainController

  describe 'Top Timer' do
    it 'It should start top timer when we tap on it' do
      top_timer_button = views(UIView)[2]

      tap top_timer_button
      proper_wait 3
      top_timer_label = views(UILabel)[0]
      top_timer_label.text.should == '24:57'
    end

    it 'It should stop top timer when we tap on it a second time and reset it' do
      top_timer_button = views(UIView)[2]

      tap top_timer_button
      proper_wait 3
      tap top_timer_button
      top_timer_label = views(UILabel)[0]
      top_timer_label.text.should == '25:00'
    end
  end

  describe 'Bottom Timer' do
    it 'It should start bottom timer when we tap on it' do
      bottom_timer_button = views(UIView)[5]

      tap bottom_timer_button
      proper_wait 3
      bottom_timer_label = views(UILabel)[1]
      bottom_timer_label.text.should == '4:57'
    end

    it 'It should stop bottom timer when we tap on it a second time and reset it' do
      bottom_timer_button = views(UIView)[5]

      tap bottom_timer_button
      proper_wait 3
      tap bottom_timer_button
      bottom_timer_label = views(UILabel)[1]
      bottom_timer_label.text.should == '5:00'
    end
  end
end