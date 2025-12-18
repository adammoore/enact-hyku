// Creation Stages Manager for Portfolio NTRO forms
// Handles dynamic add/remove of creation stage rows

(function($) {
  'use strict';

  var CreationStagesManager = function(element) {
    this.element = $(element);
    this.tbody = this.element.find('.stages-tbody');
    this.template = $('#tmpl-creation-stage').html();
    this.stages = this.element.data('stages') || [];
    this.index = 0;
  };

  CreationStagesManager.prototype = {
    init: function() {
      this.renderExistingStages();
      this.bindEvents();
    },

    bindEvents: function() {
      var self = this;

      $('[data-behavior="add-stage"]').on('click', function(e) {
        e.preventDefault();
        self.addStage();
      });

      this.tbody.on('click', '[data-behavior="remove-stage"]', function(e) {
        e.preventDefault();
        $(e.target).closest('tr').remove();
      });
    },

    renderExistingStages: function() {
      var self = this;
      this.stages.forEach(function(stage) {
        self.renderStage(stage);
      });
    },

    renderStage: function(stage) {
      stage = stage || {};
      var compiled = this.compileTemplate(this.template, { index: this.index++ });
      var $row = $(compiled);

      this.tbody.append($row);

      // Pre-fill values if editing
      if (stage.stage_type) {
        $row.find('[name*="stage_type"]').val(stage.stage_type);
      }
      if (stage.date) {
        $row.find('[name*="date"]').val(stage.date);
      }
      if (stage.location) {
        $row.find('[name*="location"]').val(stage.location);
      }
      if (stage.description) {
        $row.find('[name*="description"]').val(stage.description);
      }
      if (stage.contributors) {
        $row.find('[name*="contributors"]').val(stage.contributors);
      }
    },

    addStage: function() {
      this.renderStage({});
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
    $('[data-behavior="creation-stages"]').each(function() {
      var manager = new CreationStagesManager(this);
      manager.init();
    });
  });

})(jQuery);
