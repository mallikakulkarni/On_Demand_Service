/**
 * Created by mallika on 11/18/15.
 */


script(type="text/javascript").
    $(document).ready(function () {
        $('#sbsignupform').submit(function (e) {
            /*
             var formValues = ['name', 'email', 'password', 'street_address', 'city', 'state', 'zip', 'mobile'];
             var reqObj = {};
             for (i = 0; i < formValues.length; i++) {
             console.log(formValues[i]);
             console.log(document.getElementById(formValues[i]));
             console.log(document.getElementById(formValues[i]).value);
             reqObj[formValues[i]] = document.getElementById(formValues[i]).value;

             }
             */
            var reqObj = $(this).serialize();
            console.log(reqObj);
            $.ajax({
                contentType: 'application/json',
                type: "POST",
                url: '/business/bsignup',
                data: JSON.stringify(reqObj),
                dataType: 'json',
                success: function(res) {
                    console.log(res);
                    $("#sbsignupmodalheader").html(res);
                },
                error: function(err) {
                    console.log('An Error occured');
                    console.log(err);
                }
            });
            e.preventDefault();
        });
    });
//div(class="row")
//    div(class="finput-group col-lg-4")
//        p Select all the services that you offer!
//        span(class="input-group-addon")
//            label Cleaning
//            input(type="checkbox", class="form-control", name='service[]', value='Cleaning', checked)
//        span(class="input-group-addon")
//            label Lawn Maintenance
//            input(type="checkbox", class="form-control",  name='service[]', value='Lawn Maintenance', unchecked)
//        span(class="input-group-addon")
//            label Nanny Services
//            input(type="checkbox", class="form-control",  name='service[]', value='Nanny Services', checked)
//        span(class="input-group-addon")
//            label Plumbing
//            input(type="checkbox", class="form-control",  name='service[]', value='Plumbing', unchecked)
//        span(class="input-group-addon")
//            label Electrical
//            input(type="checkbox", class="form-control",  name='service[]', value='Electrical', unchecked)