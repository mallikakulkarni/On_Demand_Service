$(document).ready(function(){
    window.ANALYTICS_BASE_URL = "http://localhost:5000";
   $('.activate').click(function(e){
       e.preventDefault();
       var smID = $(this).data("id");
       var url = "/admin/activate_business/"+smID;
       $.ajax({
           url: url,
           success: function(d) {
               if(d.done)   {
                   $(this).removeClass('activate').addClass('deactivate').removeClass('btn-primary').addClass('btn-danger').html("Deactivate");
               }
               else {
                   //$(this).removeClass('deactivate').addClass('activate').removeClass('btn-danger').addClass('btn-primary').html("Activate");
               }
           }
       });
   });
    $('.deactivate').click(function(e){
        e.preventDefault();
        var smID = $(this).data("id");
        var url = "/admin/deactivate_business/"+smID;
        $.ajax({
            url: url,
            success: function(d) {
                if(d.done)   {
                    $(this).removeClass('deactivate').addClass('activate').removeClass('btn-danger').addClass('btn-primary').html("Activate");

                }
                else {
                    //$(this).removeClass('activate').addClass('deactivate').removeClass('btn-primary').addClass('btn-danger').html("Deactivate");
                }
            }
        });
    });
    var numbersToUpdate = [
        {
            elementID: "tv",
            url: "/admin/total_visitors"
        },
        {
            elementID: "rv",
            url: "/admin/total_registered_visitors"
        },
        {
            elementID: "vip",
            url: "/admin/visits_by_users"
        },
        {
            elementID: "vpi",
            url: "/admin/visits_by_registered_users"
        }
    ];
    for(var e in numbersToUpdate)   {
        var o = numbersToUpdate[e];
        fetchFromAnalytics(o.elementID, window.ANALYTICS_BASE_URL + o.url, '', updateValue);
    }

    var graphsToUpdate = [
        {
            elementID: 'container1',
            url: '/admin/daily_visits',
            title: 'Average Daily Visits'
        },
        {
            elementID: 'container2',
            url: '/admin/daily_registered_visits',
            title: 'Average Daily Registered Visits'
        }
    ];

    for(var e in graphsToUpdate)    {
        fetchFromAnalytics(graphsToUpdate[e].elementID, window.ANALYTICS_BASE_URL + graphsToUpdate[e].url, graphsToUpdate[e].title,drawgraph);
    }
});

function updateValue(elementID, data)   {
    $("#"+elementID).html(data);
}

function fetchFromAnalytics(elementID, url, title, callback) {
    $.ajax({
        url:url,
        success: function(d)    {
            callback(elementID, d.result, title);
        }
    });
}

function drawgraph(elementID, data, title) {
    var categories = [];
    var values = [];
    for(var d in data)  {
        categories.push(new Date(data[d]._id.date.$date));
        values.push(data[d].count);
    }
    $('#'+elementID).highcharts({
        chart:  {
          type: 'line'
        },
        title: {
            text: title,
            x: -20 //center
        },
        xAxis: {
            categories: categories
        },
        yAxis: {
            title: {
                text: 'Number of users'
            }
        },
        tooltip: {
            valueSuffix: 'users'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: title,
            data: values
        }]
    });
}