# Description:
#   register emoji to slack
#
# Notes:
#
request = require 'request'
yaml = require 'js-yaml'

module.exports = (robot) ->
  # define url
  pokemonurl = "https://raw.githubusercontent.com/templarian/slack-emoji-pokemon/master/pokemon.yaml"
  pokemonjpurl = "https://raw.githubusercontent.com/Templarian/slack-emoji-pokemon/master/translations/ja/pokemon.ja.yaml"

  # error handler
  robot.error (err, res) ->
    console.log(err)
    if res?
      res.send "[error] #{err}"

  # parse yaml
  parseyaml = (txt) ->
    try
      return yaml.safeLoad(txt)
    catch err
      robot.emit 'error', err

  # regemo pokemon method
  robot.respond /add emoji (.*) from (pokemonjp|pokemon)/i , (res) ->
    inputs = res.match[1].split(",")
    url = if res.match[2] is "pokemon" then pokemonurl else pokemonjpurl
    # get emoji source
    option =
      url: url
      timeout: 2000
    request option, (error, response, body) ->
      if error or response.statusCode isnt 200
        errmsg = "[status code:#{response.statusCode}] failed to request #{url}"
        robot.emit 'error', new Error(errmsg)
      source = parseyaml(body)
      # serach emojs from source
      emojis = {}
      for srcEmoji in source.emojis
        if srcEmoji.name in inputs
          emojis[srcEmoji.src] =
            name: srcEmoji.name
            url: srcEmoji.src
      # get emoji in english if emojis.name is japanese
      if url is pokemonjpurl
        option =
          url: pokemonurl
          timeout: 2000
        request option, (error, response, body) ->
          if error or response.statusCode isnt 200
            errmsg = "[status code:#{response.statusCode}] failed to request #{pokemonurl}"
            robot.emit 'error', new Error(errmsg)
          ensource = parseyaml(body)
          # serach emojs from ensource
          for ensrcEmoji in ensource.emojis
            if ensrcEmoji.src of emojis is true
              altname = emojis[ensrcEmoji.src].name
              emojis[ensrcEmoji.src].name = ensrcEmoji.name
              emojis[ensrcEmoji.src].altname = altname
          # send message
          for key,val of emojis
            name = val.name
            url = val.url
            altname = if val.altname? then val.altname else "none"
            res.send("name: #{name}\nurl: #{url}\naltname: #{altname}")
