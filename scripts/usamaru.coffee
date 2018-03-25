# Description:
#   register emoji to slack
#
# Notes:
#
rp= require 'request-promise'
cheerio = require('cheerio')
urls =
  "usamaru1url": "https://store.line.me/stickershop/product/1008068/ja"
  "usamaru2url": "https://store.line.me/stickershop/product/1043050/ja"
  "usamaru3url": "https://store.line.me/stickershop/product/1074536/ja"
  "usamaru4url": "https://store.line.me/stickershop/product/1126917/ja"
  "usamaru5url": "https://store.line.me/stickershop/product/1143809/ja"
  "usamaru6url": "https://store.line.me/stickershop/product/1208866/ja"
  "usamaru7url": "https://store.line.me/stickershop/product/1259404/ja"
  "usamaru8url": "https://store.line.me/stickershop/product/1289247/ja"
  "usamaru9url": "https://store.line.me/stickershop/product/1412536/ja"
  "usamaru10url": "https://store.line.me/stickershop/product/3128490/ja"

getcontents = (url) ->
  option =
    url: url
    timeout: 2000
    transform: (body) ->
      return cheerio.load(body);
  return rp(option);

module.exports = (robot) ->
  # error handler
  robot.error (err, res) ->
    console.log(err)
    if res?
      res.send "[error] #{err}"

  # regemo usamaru method
  robot.respond /(usamaru\d{1,2})/i , (res) ->
    inputs = res.match[1]
    url = "#{inputs}url"
    if url of urls is true
      getcontents(urls["#{url}"])
      .then ($) ->
        imgs = []
        $('.mdCMN09Image').each ->
          styleattr = $(this).attr('style')
          match = styleattr.match(/.+url\((.+);.+\);/)
          imgs.push(match[1])
        # pick up at random
        ran = Math.floor(Math.random() *  imgs.length);
        img = imgs[ran]
        res.send("#{img}")
