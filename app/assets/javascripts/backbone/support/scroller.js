Support.Scroller = {
  scrollToBottom: function() {
    var height = this.el.scrollHeight;
    this.$el.animate({
      scrollTop: height
    }, 500);
  }
}
