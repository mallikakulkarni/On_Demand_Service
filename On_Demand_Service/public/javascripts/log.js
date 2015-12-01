/**
 * Created by nagkumar on 30/11/15.
 */
function log(userID, workerID, businessID, searchTerm, pageName, action, ipAdress, referrer)  {
    var obj = {};
    obj.action = action;
    obj.pageName = pageName;
    obj.userID = userID;
    obj.workerID = workerID;
    obj.businessID = businessID;
    obj.searchTerm = searchTerm;
    obj.ipAddress = ipAdress;
    obj.referrer = referrer;

    $.ajax({
        url: "http://50c20896.ngrok.io/log/",
        type: 'POST',
        data: obj,
        success: function(d)    {
            console.log(d);
        }
    })
}

// include this js and call the function like this
//getParamsAndLog(userID, workerID, businessID, searchTerm, pageName, action, ipAdress)
//ex getParamsAndLog(1, 1, 1, 'abc', 'home', 'load', '10.1.0.1')
function getParamsAndLog(userID, workerID, businessID, searchTerm, pageName, action, ipAdress)  {
    log(userID||"", workerID||"", businessID||"", searchTerm||"", pageName||"", action||"", ipAdress||"", document.referrer);
}