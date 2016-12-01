(function($){
  $(document).on('ready page:load', function(){
    
    $("#pro-cal-button").hide(0);
    
    if (proUser) {
      $("#pro-cal-button").show();
      $("#checkboxid").prop('checked', true);
    }
    
    $("#pro-toggle").click(function () {
      
    tog_url = "/users/" + userId + "/toggle";
    check = $("#pro-toggle").is(":checked");
    if(check) {
        //use ajax to change to pro user. show the button for my calendar 
        $("#pro-cal-button").show();
        
    } else {
        //use ajax to change pro to non user. make button disappear
        $("#pro-cal-button").hide(0);
    }
    
      $.ajax({
          type: "PUT",
          url: tog_url,
          success: function (msg) {
            alert('Success');
            if (msg != 'success') {
                alert('Fail');
            }
          },
          error: function(response) {
                console.log(response.status + " " + response.statusText);
          }
          });
    
  
      });
  });
 
})(jQuery); // end of jQuery name space

;