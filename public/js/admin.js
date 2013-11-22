$(function() {
  $("#new-page-dialog").dialog({
        autoOpen: false,
        height: 300,
        width: 420,
        modal: true,
        buttons: {
          "Seite erstellen": function() {
            $.ajax({
              url: "/admin/pages/create",
              method: "post",
              data: {
                page: {
                  title: $("#page-title").val(),
                  type: $("#page-type").val()
                }
              }
            });
          },
          "Abbrechen": function() {
            $(this).dialog( "close" );
          }
        }
  });

  SeeMS.Admin.$sortable = $('.sortable');

  $("#new-page").click(function() {
    $("#new-page-dialog").dialog("open");
  });

  SeeMS.Admin.$sortable.sortable();
  SeeMS.Admin.fetchPages();
});

SeeMS = window.SeeMS || {};
jQuery.extend(SeeMS, {
  Admin: {

    // Fetch top pages
    fetchPages: function() {
      var self = this;
      $.ajax({
        method: 'get',
        url: '/admin/pages',
        success: function(data) {
          self.$sortable.html("");
          JSON.parse(data).each(function(page) {
            $li = $("<li></li>");
            $li.text(page.title);
            $li.attr("id", page._id);
            self.$sortable.append($li);
          });
        }
      });
    }, // fetchPages

    updateApplication: function() {
      var self = this;
      $.ajax({
        method: 'post',
        url: '/admin/app/update',
        data: {
          application: {
            page_ids: self.$sortable.sortable("toArray")
          }
        },
        success: function(data) {
          alert('success');
        }
      });
    } // updateApplication
  } // Admin
}); // jQuery.extend
