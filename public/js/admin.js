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

  $("#new-page").click(function() {
    $("#new-page-dialog").dialog("open");
  });

  $(".sortable").sortable();
  SeeMS.Admin.fetchPages();
});

SeeMS = window.SeeMS || {};
jQuery.extend(SeeMS, {
  Admin: {
    fetchPages: function() {
      $.ajax({
        method: 'get',
        url: '/admin/pages',
        success: function(data) {
          $sortable = $("ul.sortable");
          $sortable.html("");
          JSON.parse(data).each(function(page) {
            $li = $("<li></li>");
            $li.text(page.title);
            $li.attr("id", page._id);
            $sortable.append($li);
          });
        }
      });
    } // fetchPages
  } // Admin
}); // jQuery.extend
