displayHomepage = ->
  $("#homepage").css "display", "block"
  _gaq.push ['_trackPageview'] # standard pageview

loadAndDisplayGist = (gistId) ->
  window.gistId = gistId
  src = "https://api.github.com/gists/" + gistId
  $(document).ajaxError (event, xhr) ->
    $("#error").css "display", "block"
    $("#error-response").text xhr.responseText
    $("#error-gist-number").text "#" + gistId
    $("#error-gist-link").attr("href", src).text src
    $("#error-gist-index-link").attr "href", "https://gist.github.com/" + gistId
    _gaq.push ['_trackPageview', '/error/'+gistId] # virtual error pageview
    console.log "failed to fetch the content"

  console.log "fetching #{src}..."
  $.get src, (content) ->
    console.log "received", content

    headerSource = content.files?["header.html"]?.content or ""
    comixSource = content.files?["index.html"]?.content or ""
    footerSource = content.files?["footer.html"]?.content or ""

    $stage = $("<iframe/>",
      class: "stage"
      frameborder: 0
      allowTransparency: "true"
    )
    $("#comix-placeholder").append headerSource, $stage, footerSource
    doc = $stage.contents().get(0)
    doc.open()
    doc.write comixSource
    doc.close()
    $("#comix").css "display", "block"
    _gaq.push ['_trackPageview', '/gist/'+gistId] # virtual gist pageview

$ ->

  hash = location.hash.substring(1)

  # disqus uses #comment-12345 style hashes
  if hash.match /^comment/
    hash = undefined

  if hash
    loadAndDisplayGist(hash)
  else
    displayHomepage()
