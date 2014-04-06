Support.Scroller = {
  scrollToBottom: function() {
    this._scrollToHeight(this.el.scrollHeight);
  },
  isAtBottom: function() {
    var belowScrollbar = this.el.scrollHeight -
                         this.$el.outerHeight() - this.$el.scrollTop();

    // For some reason, in the action list at least, that calculation gets us 1
    // when we're scrolled to the bottom, not 0.  For now, we fudge.
    return belowScrollbar <= 10;
  },

  // Sometimes we want to scroll to a thing before the DOM is totally there and
  // such.  This is a nasty hack over that.
  scrollToTargetAtEarliestOpportunity: function(target) {
    var self = this;
    var scrollUnlessAtTarget = function() {
      if (self.targetIsOnScreen(target)) {
        clearInterval(self._scrollerIntervalId);
      } else {
        self.scrollTargetOnScreen(target);
      }
    };
    scrollUnlessAtTarget();

    if (this._scrollerIntervalId) {
      clearInterval(this._scrollerIntervalId);
    }
    this._scrollerIntervalId = setInterval(scrollUnlessAtTarget, 300);
  },
  scrollTargetOnScreen: function(target) {
    if (target) {
      var targetTop = target.$el.position().top;
      var windowHeight = this.$el.innerHeight();
      var currentScroll = this.$el.scrollTop();

      this._scrollToHeight((targetTop + currentScroll) -
                           (windowHeight * this._fractionOfScreenAboveTarget));
    } else {
      this.scrollToBottom();
    }
  },
  targetIsOnScreen: function(target) {
    if (target) {
      var targetTop = target.$el.position().top;
      var windowHeight = this.$el.innerHeight();

      return targetTop >= 0 && targetTop <= windowHeight;
    } else {
      return this.isAtBottom();
    }
  },

  _fractionOfScreenAboveTarget: 0.3,
  _scrollToHeight: function(height) {
    this.$el.scrollTop(height);
  }
}
