# Opens UIView to add methods for working with gesture recognizers.

class UIView

  def whenTapped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UITapGestureRecognizer.alloc.initWithTarget(proc, action: :'call:'))
  end

  def whenPinched(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPinchGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenRotated(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIRotationGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenSwiped(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UISwipeGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPanned(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UIPanGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  def whenPressed(enableInteraction=true, &proc)
    addGestureRecognizerHelper(proc, enableInteraction, UILongPressGestureRecognizer.alloc.initWithTarget(proc, action:'call'))
  end

  private

  # Adds the recognizer and keeps a strong reference to the Proc object.
  def addGestureRecognizerHelper(proc, enableInteraction, recognizer)
    setUserInteractionEnabled true if enableInteraction && !isUserInteractionEnabled
    self.addGestureRecognizer(recognizer)
    @recognizers = {} unless @recognizers
    @recognizers["#{proc}"] = proc
  end

end

class TimerController < UIViewController
  def viewDidLoad
    margin = 20

    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(30)
    @state.text = 'Tap to start'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 200], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@state)

    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Start', forState:UIControlStateNormal)
    @action.setTitle('Stop', forState:UIControlStateSelected)
    @action.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    @action.whenTapped do |gesture_recognizer|
      puts "gesture_recognizer: #{gesture_recognizer}"
      actionTapped
    end

    @action.frame = [[margin, 260], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@action)
  end

  def actionTapped
    if @timer
      @timer.invalidate
      @timer = nil
    else
      @duration = 0
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
    @action.selected = !@action.selected?
  end

  def timerFired
    @state.text = "%.1f" % (@duration += 0.1)
  end
end
