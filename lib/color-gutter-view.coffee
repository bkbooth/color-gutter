{Subscriber} = require 'emissary'

module.exports =
class ColorGutterView
  Subscriber.includeInto(this)

  constructor: (@editorView) ->
    {@editor, @gutter} = @editorView
    @decorations = {}
    @markers = null

    @subscribe @editorView, 'editor:path-changed', @subscribeToBuffer

    @subscribeToBuffer()

    @subscribe @editorView, 'editor:will-be-removed', =>
      @unsubscribe()
      @unsubscribeFromBuffer()

  destroy: ->
    @unsubscribeFromBuffer()

  unsubscribeFromBuffer: ->
    if @buffer?
      @removeDecorations()
      @buffer.off 'contents-modified', @updateColors
      @buffer = null

  subscribeToBuffer: ->
    @unsubscribeFromBuffer()

    if @buffer = @editor.getBuffer()
      @scheduleUpdate()
      @buffer.on 'contents-modified', @updateColors

  scheduleUpdate: ->
    setImmediate(@updateColors)

  updateColors: =>
    @removeDecorations()

    # Is one of these more performant?
    # for line, index in @editor.getText().split('\n')
    #   matches = regexp.exec line
    # for line in [0...@editor.getLineCount()]
    #   matches = regexp.exec @editor.lineForBufferRow(line)
    regexp = /#([0-9a-f]{6}|[0-9a-f]{3})[\s;]/im
    for line in [0...@editor.getLineCount()]
      matches = regexp.exec @editor.lineForBufferRow(line)
      if matches?
        @markLine line, @makeColor('hex', matches[1])

  makeColor: (pattern, match) ->
    switch pattern
      when 'hex' then "##{match}"

  removeDecorations: ->
    return unless @markers?
    marker.destroy() for marker in @markers
    @markers = null

  markLine: (line, color) ->
    marker = @editor.markScreenPosition([line, 0], invalidate: 'never')
    @editor.decorateMarker(marker, type: 'gutter', class: 'color-gutter')
    @editorView.find('.line-number-' + line).css({ 'border-right-color': color })
    @markers ?= []
    @markers.push marker
