// Rights Holders Manager for Portfolio NTRO forms
// Handles dynamic add/remove of rights holder rows

(function($) {
  'use strict';

  var RightsHoldersManager = function(element) {
    this.element = $(element);
    this.tbody = this.element.find('.holders-tbody');
    this.template = $('#tmpl-rights-holder').html();
    this.holders = this.element.data('holders') || [];
    this.index = 0;
  };

  RightsHoldersManager.prototype = {
    init: function() {
      this.renderExistingHolders();
      this.bindEvents();
    },

    bindEvents: function() {
      var self = this;

      $('[data-behavior="add-holder"]').on('click', function(e) {
        e.preventDefault();
        self.addHolder();
      });

      this.tbody.on('click', '[data-behavior="remove-holder"]', function(e) {
        e.preventDefault();
        $(e.target).closest('tr').remove();
      });
    },

    renderExistingHolders: function() {
      var self = this;
      this.holders.forEach(function(holder) {
        self.renderHolder(holder);
      });
    },

    renderHolder: function(holder) {
      holder = holder || {};
      var compiled = this.compileTemplate(this.template, { index: this.index++ });
      var $row = $(compiled);

      this.tbody.append($row);

      // Pre-fill values if editing
      if (holder.entity_name) {
        $row.find('[name*="entity_name"]').val(holder.entity_name);
      }
      if (holder.entity_type) {
        $row.find('[name*="entity_type"]').val(holder.entity_type);
      }
      if (holder.entity_role) {
        $row.find('[name*="entity_role"]').val(holder.entity_role);
      }
      if (holder.rights_percentage) {
        $row.find('[name*="rights_percentage"]').val(holder.rights_percentage);
      }
      if (holder.cultural_context) {
        $row.find('[name*="cultural_context"]').val(holder.cultural_context);
      }
    },

    addHolder: function() {
      this.renderHolder({});
    },

    compileTemplate: function(template, data) {
      // Simple template compilation (replaces {{= key }} with values)
      return template.replace(/\{\{=\s*(\w+)\s*\}\}/g, function(match, key) {
        return data[key] || '';
      });
    }
  };

  // Initialize on page load
  $(document).on('turbolinks:load ready', function() {
    $('[data-behavior="rights-holders"]').each(function() {
      var manager = new RightsHoldersManager(this);
      manager.init();
    });
  });

})(jQuery);
