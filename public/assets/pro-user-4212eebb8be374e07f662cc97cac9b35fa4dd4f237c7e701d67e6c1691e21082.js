(function($){
  $(document).on('ready page:load', function(){
    
    // if (proUser) {
    //   $("#pro-cal-button").show();
    //   $("#checkboxid").prop('checked', true);
    //   $("#pro-cal-button").hide();
      
    // }
    
    $("#pro-toggle").click(function () {
      
    var tog_url = "/users/" + userId + "/toggle";
    
    var check = $("#pro-toggle").is(":checked");
    if(check) {
        //use ajax to change to pro user. show the button for my calendar 
        $("#pro-cal-button").show();
        $("#checkboxid").prop('checked', true);
        
    } else {
        //use ajax to change pro to non user. make button disappear
        $("#pro-cal-button").hide();
        $("#checkboxid").prop('checked', false);
    }
    
       $.ajax({
            type: "POST",
            url: tog_url,
            data: {var: "true"},
            success: function (msg) {
                alert('Success');
                if (msg != 'success') {
                 alert('Fail');
                }
            },
            dataType: 'json',
            error: function(response) {
                console.log(response.status + " " + response.statusText);
            }
        });
    
  
      });
  });
 
})(jQuery); // end of jQuery name space

;