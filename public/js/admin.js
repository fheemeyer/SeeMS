$(function() {
  SeeMS.Admin.$pages = $('#pages');

  $("#new-page").click(function() {
    $("#new-page-dialog").dialog("open");
  });

  $("#save-app").click(function() {
    SeeMS.Admin.updateApplication(function() {
      SeeMS.Admin.fetchPages();
    });
  });

  $("#page-type").change(function() {
    $pageChildren = $("#page-children");
    if($(this).val() == "content") {
      $("#page-url").add("#page-parent")
        .add("#page-url-label").add("#page-parent-label").fadeIn();
    }
    else {
      $("#page-url").add("#page-parent")
        .add("#page-url-label").add("#page-parent-label").fadeOut();
    }
  });

  SeeMS.Admin.createNewPageDialog();
  SeeMS.Admin.$pages.sortable();
  SeeMS.Admin.fetchPages();
});

SeeMS = window.SeeMS || {};
jQuery.extend(SeeMS, {
  Admin: {

    NavigationPages: [],

    // # Pure AJAX related #

    // Fetch top pages
    fetchPages: function() {
      var self = this;
      self.$pages.fadeOut();
      $.ajax({
        method: 'get',
        url: '/admin/pages',
        success: function(data) {
          self.$pages.html("");
          JSON.parse(data).each(function(page) {
            self.createPageLi(page);
            if(page.type == "navigation") {
              self.NavigationPages.push(page);
            }
          });
          self.addNavigationPageOptions();
          self.$pages.fadeIn();
        }
      });
    }, // fetchPages

    fetchChildren: function(id, callback) {
      var self = this;
      $.ajax({
        method: 'get',
        url: '/admin/' + id + '/children',
        success: function(data) {
          callback(JSON.parse(data));
        }
      });
    }, // fetchChildren

    createPage: function() {
      var pageData =  {
        title: $("#page-title").val(),
        type: $("#page-type").val()
      };
      if($("#page-type").val() == "content") {
        jQuery.extend(pageData, {
          url: $("#page-url").val(),
          parent: $("#page-parent").val()
        });
      }

      $.ajax({
        url: "/admin/pages/create",
        method: "post",
        data: {
          page: pageData
        },
        success: function() {
          SeeMS.Admin.fetchPages();
        }
      });
    },

    updateApplication: function(callback) {
      var self = this;
      $.ajax({
        method: 'post',
        url: '/admin/app/update',
        data: {
          application: {
            child_ids: self.$pages.sortable("toArray")
          }
        },
        success: function(data) {
          if(callback) {
            callback();
          }
        }
      });
    }, // updateApplication

    // # Dom Manipulation #

    createNewPageDialog: function() {
      var self = this;
      $("#new-page-dialog").dialog({
        autoOpen: false,
        height: 420,
        width: 420,
        title: "Seite erstellen",
        modal: true,
        buttons: {
          "Seite erstellen": function() {
            self.createPage();
            $(this).dialog("close");
          },
          "Abbrechen": function() {
            $(this).dialog("close");
          }
        }
      }); // Dialog
    }, // createNewPageDialog

    createPageLi: function(page) {
      var $li = $('<li class="page"></li>');
      var $div = $('<div></div>');
      $div.text(page.title);
      $li.append($div);
      this.createDeleteButton($div);
      if(page.type == "navigation") {
        this.createChildrenButton($div);
      }
      else {
        this.createEditButton($div);
      }
      $li.attr("id", page._id);
      this.$pages.append($li);
    }, //createPageLi

    createDeleteButton: function($div) {
      var $deleteSpan = $('<span class="rm-page glyphicon glyphicon-remove"></span>');
      $div.append($deleteSpan);
      $deleteSpan.click(function(e) {
        $div.fadeOut(function() {
          $(this).remove();
        });
      });
    }, //createDeleteButton

    createEditButton: function($div) {
      var self = this;
      var $editSpan = $('<span class="edit-page glyphicon glyphicon-pencil"></span>');
      $div.append($editSpan);
      $editSpan.click(function(e) {
        self.openEditPage($div.parent().attr("id"));
      });
    }, //createDeleteButton

    createChildrenButton: function($div) {
      var self = this;
      var $childSpan = $('<span class="children glyphicon glyphicon-chevron-down"></span>');
      $div.append($childSpan);
      $childSpan.click(function(e) {
        if($childSpan.hasClass("glyphicon-chevron-down")) {
          $childSpan.removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");
          self.addChildren($div.parent());
        }
        else {
          $childSpan.removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
          $div.parent().find("ul").remove();
        }
      }); // click
    }, //createDeleteButton

    addChildren: function($li) {
      var $ul = $('<ul></ul>');
      var parentId = $li.attr('id');
      this.fetchChildren($li.attr('id'), function(children) {
        children.each(function(child) {
          var $childLi = $('<li id="'+child._id+'" class="child '+parentId+'">'+child.title+'</li>');
          $ul.append($childLi);
        });
        $li.append($ul);
        $ul.sortable();
      }); // fetchChildren
    }, // addChildren

    // For dialog
    addNavigationPageOptions: function() {
      $pageParent = $("#page-parent");
      $pageParent.find("option.page").remove();
      this.NavigationPages.each(function(navPage) {
        $option = $('<option value="'+navPage._id+'" class="page">'+navPage.title+'</option>');
        $pageParent.append($option);
      });
    }, //addNavigationPageOptions

    // # all other stuff #

    openEditPage: function(id) {
      window.open('/admin/pages/' + id + '/edit', "_blank");
      window.focus();
    }
  } // Admin
}); // jQuery.extend
