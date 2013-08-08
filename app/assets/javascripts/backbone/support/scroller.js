Support.Scroller = {
  scrollToBottom: function() {
    var height = this.el.scrollHeight;
    this.$el.scrollTop(height);
  },
  isAtBottom: function() {
    var belowScrollbar = this.el.scrollHeight -
                         this.$el.outerHeight() - this.$el.scrollTop();

    // For some reason, in the action list at least, that calculation gets us 1
    // when we're scrolled to the bottom, not 0.  For now, we fudge.
    return belowScrollbar <= 10;
  }
}
