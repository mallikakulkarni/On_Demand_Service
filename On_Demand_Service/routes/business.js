var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/bsignup', function(req, res, next) {
  res.render('businesshomepage');
});

module.exports = router;
