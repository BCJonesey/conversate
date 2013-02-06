(function() {
  var option = function(token) {
    return $('<li class="token-option" data-token-id="' + token.id + '">' + token.name + '</li>');
  }

  var token = function(option) {
    return $('<li class="token participant" data-token-id="' +
             option.attr('data-token-id') + '">' +
             option.text() + '<span class="participant-remove">x</span></li>');
  }

  var targetUp = function(root) {
    var target = root.find('.token-option.target');
    var before = target.prev('.token-option');
    if (before.length > 0) {
      target.removeClass('target');
      before.addClass('target');
    }
  }

  var targetDown = function(root) {
    var target = root.find('.token-option.target');
    var after = target.next('.token-option');
    if (after.length > 0) {
      target.removeClass('target');
      after.addClass('target');
    }
  }

  var selectOption = function(root) {
    var target = root.find('.token-option.target');
    if (target.length == 0) { return; }

    var input = root.find('input');
    input.parent().before(token(target));
    input.val('');
    refreshOptions(root);
  }

  var refreshOptions = function(root, tokens) {
    var input = root.find('input');
    var options = root.find('.token-options');
    if (input.val().trim().length == 0) {
      options.html('');
    }
    else {
      var query = new RegExp(input.val(), 'i');
      options.empty();
      var optionTags = tokens.filter(function(token) { return query.test(token.name); });
      optionTags = optionTags
                             .filter(function(token) {
                               var tokens = root.find('.token');
                               for (var i = 0; i < tokens.length; i++) {
                                 if ($(tokens[i]).attr('data-token-id') == (token.id+ '')) {
                                   return false;
                                 }
                               }
                               return true;
                             });
      if (optionTags.length == 0) { return; }
      optionTags = optionTags.map(function(token) { return option(token); });

      var firstTag = optionTags.shift();
      firstTag.addClass('target');
      options.append(firstTag);
      options.append(optionTags);
    }
  }

  window.tokenize = function(input, tokenList, prefill) {
    tokenList = tokenList || [];
    prefill = prefill || [];

    input.addClass("token-input");
    input.wrap($('<div class="token-container participants-list"><ul class="tokens"><li class="token-input-wrap"></li></ul></div>'));
    var container = input.parents('.token-container').first();

    var options = $('<ul class="token-options"></ul>');
    container.append(options);

    var tokens = container.find('.tokens');

    var prefillTokens = function() {
      var inputWrap = container.find('.token-input-wrap');
      prefill.forEach(function(tok) {
        inputWrap.before(token(option(tok)));
      });
    }

    prefillTokens();
    tokens.prepend('<li class="user-reminder">You, and...</li>');

    $('.cnv-info-participants-edit').on('click', function() {
      input.removeAttr('readonly');
      input.focus();
      container.addClass('focus');
      $('.cnv-info-participants-save-actions').removeClass('hidden');
      $('.cnv-info-participants-actions').addClass('hidden');
    });

    var closeParticipants = function() {
      input.blur();
      input.attr('readonly', 'readonly');
      container.removeClass('focus');
      $('.cnv-info-participants-save-actions').addClass('hidden');
      $('.cnv-info-participants-actions').removeClass('hidden');
    }

    $('.cnv-info-participants-save').on('click', function() {
      closeParticipants();
    })

    $('html').on('click', function(e) {
      var target = $(e.target);
      console.log(target.parents());
      if (target.closest('html').length > 0 &&
          target.closest('.cnv-info-participants').length == 0) {
        $('.token').remove();
        prefillTokens();
        closeParticipants();
      }
    })

    input.on('keyup', function(e) {
      if (e.which == 38) { // Up
        targetUp(container);
      }
      else if (e.which == 40) { // Down
        targetDown(container);
      }
      else if (e.which == 13) { // Enter
        e.preventDefault();
        e.stopPropagation();
        selectOption(container);
      }
      else {
        refreshOptions(container, tokenList);
      }
    });

    input.on('keydown', function(e) {
      if (e.which == 13) {
        e.preventDefault();
        e.stopPropagation();
      }
    });

    $('.token-option').live('mouseover', function(e) {
      var currentTarget = $('.token-option.target');
      var target = $(e.target);

      if (!target.hasClass('target')) {
        currentTarget.removeClass('target');
        target.addClass('target');
      }
    });

    $('.token-option').live('click', function(e) {
      selectOption(container);
      input.focus();
    });

    $('.token .participant-remove').live('click', function(e) {
      $(e.target).parents('.token').first().remove();
      input.focus();
    });
  };
})();
