# Description:
#   register emoji to slack
#
# Notes:
#
request = require 'request-promise'
cheerio = require('cheerio')
usamaru1url = "https://store.line.me/stickershop/product/1008068/ja"
usamaru2url = "https://store.line.me/stickershop/product/1043050/ja"
usamaru3url = "https://store.line.me/stickershop/product/1074536/ja"
usamaru4url = "https://store.line.me/stickershop/product/1126917/ja"
usamaru5url = "https://store.line.me/stickershop/product/1143809/ja"
usamaru6url = "https://store.line.me/stickershop/product/1208866/ja"
usamaru7url = "https://store.line.me/stickershop/product/1259404/ja"
usamaru8url = "https://store.line.me/stickershop/product/1289247/ja"
usamaru9url = "https://store.line.me/stickershop/product/1412536/ja"
usamaru10url = "https://store.line.me/stickershop/product/3128490/ja"


module.exports = (robot) ->
  # error handler
  robot.error (err, res) ->
    console.log(err)
    if res?
      res.send "[error] #{err}"

  # regemo pokemon method
  robot.respond /add emoji (.*) from (pokemonjp|pokemon)/i , (res) ->
