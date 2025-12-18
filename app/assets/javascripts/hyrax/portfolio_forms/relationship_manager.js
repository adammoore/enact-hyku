// Portfolio Relationship Manager
// Handles version, performance, exhibition, and derivative relationships

(function($) {
  'use strict';

  var RelationshipManager = function() {
    this.template = $('#tmpl-relationship').html();
    this.relationshipIndex = 0;
  };

  RelationshipManager.prototype = {
    init: function() {
      this.setupAutocomplete();
      this.bindAddButtons();
      this.bindRemoveButtons();
      this.renderExistingRelationships();
    },

    setupAutocomplete: function() {
      var self = this;

      $('.relationship-autocomplete').each(function() {
        var $input = $(this);
        var relationship = $input.data('relationship');

        $input.autocomplete({
          minLength: 2,
          source: function(request, response) {
            $.ajax({
              url: '/catalog.json',
              dataType: 'json',
              data: {
                q: request.term,
                'f[has_model_ssim][]': 'Portfolio'
              },
              success: function(data) {
                var results = data.response.docs.map(function(doc) {
                  return {
                    label: doc.title_tesim ? doc.title_tesim[0] : doc.id,
                    value: doc.id
                  };
                });
                response(results);
              },
              error: function() {
                response([]);
              }
            });
          },
          select: function(event, ui) {
            event.preventDefault();
            self.addRelationship(relationship, ui.item.value, ui.item.label);
            $input.val(''); // Clear the input after selection
            return false;
          }
        });
      });
    },

    bindAddButtons: function() {
      var self = this;

      $('[data-behavior="add-relationship"]').on('click', function(e) {
        e.preventDefault();
        var $button = $(e.currentTarget);
        var $section = $button.closest('.relationship-section');
        var relationship = $section.data('relationship');
        var $input = $section.find('.relationship-autocomplete');
        var query = $input.val().trim();

        if (query) {
          // Trigger autocomplete search
          $input.autocomplete('search', query);
        }
      });
    },

    bindRemoveButtons: function() {
      var self = this;

      $(document).on('click', '[data-behavior="remove-relationship"]', function(e) {
        e.preventDefault();
        var $row = $(e.currentTarget).closest('tr');
        $row.find('.destroy-field').val('true');
        $row.hide();
      });
    },

    addRelationship: function(relationship, workId, title) {
      var data = {
        relationship: relationship,
        id: workId,
        title: title,
        index: this.relationshipIndex++
      };

      var compiled = this.compileTemplate(this.template, data);
      var $row = $(compiled);

      // Find the appropriate table
      var tableId = relationship.replace(/-/g, '_');
      $('#' + tableId + ' tbody').append($row);
    },

    renderExistingRelationships: function() {
      // This would be called with existing data from the form
      // Implementation depends on how existing relationships are passed to the form
    },

    compileTemplate: function(template, data) {
      // Simple template compilation (replaces {{= key }} with values)
      return template.replace(/\{\{=\s*(\w+)\s*\}\}/g, function(match, key) {
        return self.escapeHtml(data[key] || '');
      });
    },

    escapeHtml: function(text) {
      var map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
      };
      return text.toString().replace(/[&<>"']/g, function(m) { return map[m]; });
    }
  };

  // Initialize on page load
  $(document).on('turbolinks:load ready', function() {
    if ($('[data-behavior$="-manager"]').length > 0) {
      var manager = new RelationshipManager();
      manager.init();
    }
  });

})(jQuery);
