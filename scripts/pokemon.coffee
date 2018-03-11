# Description:
#   register emoji to slack
#
# Notes:
#
rp = require 'request-promise'
yaml = require 'js-yaml'
pokemonurl = "https://raw.githubusercontent.com/templarian/slack-emoji-pokemon/master/pokemon.yaml"
pokemonjpurl = "https://raw.githubusercontent.com/Templarian/slack-emoji-pokemon/master/translations/ja/pokemon.ja.yaml"

getcontents = (url) ->
  option =
    url: url
    timeout: 2000
    transform: (body) ->
      return yaml.safeLoad(body);
  return rp(option);

module.exports = (robot) ->
  # error handler
  robot.error (err, res) ->
    console.log(err)
    if res?
      res.send "[error] #{err}"

  # pokemon emoji
  robot.respond /add emoji (.*) from (pokemonjp|pokemon)/i , (res) ->
    inputs = res.match[1].split(",")
    url = if res.match[2] is "pokemon" then pokemonurl else pokemonjpurl
    emojis = {}
    # predefined: send emoji
    sendemoji = () ->
      for key,val of emojis
        name = val.name
        altname = if val.altname? then val.altname else "none"
        url = val.url
        res.send("name: #{name}\naltname: #{altname}\nurl: #{url}")
    # get emoji
    getcontents(url)
    .then (contents) ->
      for emoji in contents.emojis
        if emoji.name in inputs
          emojis[emoji.src] =
            name: emoji.name
            url: emoji.src
      if url is pokemonjpurl
        return getcontents(pokemonurl)
      else
        sendemoji()
    .then (contents) ->
      for emoji in contents.emojis
        if emoji.src of emojis is true
          altname = emojis[emoji.src].name
          emojis[emoji.src].name = emoji.name
          emojis[emoji.src].altname = altname
      sendemoji()
    .catch (err) ->
      robot.emit 'error', err
