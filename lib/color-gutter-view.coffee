{Subscriber} = require 'emissary'
RegExps = require './color-gutter-regexps'

module.exports =
class ColorGutterView
  Subscriber.includeInto(this)

  constructor: (@editorView) ->
    {@editor, @gutter} = @editorView
    @decorations = {}
    @markers = null
    @updateTimer = null

    @config =
      updateInterval: atom.config.get 'color-gutter.updateInterval'
      ignoreCommentedLines: atom.config.get 'color-gutter.ignoreCommentedLines'

    @watchConfigChanges()

    @subscribe @editorView, 'editor:display-updated', @subscribeToBuffer

    @subscribe @editorView, 'editor:will-be-removed', =>
      @unsubscribe()
      @unsubscribeFromBuffer()

  watchConfigChanges: =>
    @subscribe atom.config.observe 'color-gutter.updateInterval', (updateInterval) =>
      updateInterval = parseInt updateInterval, 10
      updateInterval = 200 if isNaN(updateInterval) or updateInterval < 0
      unless updateInterval == @config.updateInterval
        @config.updateInterval = updateInterval
        @subscribeToBuffer()

    @subscribe atom.config.observe 'color-gutter.ignoreCommentedLines', (ignoreCommentedLines) =>
      unless ignoreCommentedLines == @config.ignoreCommentedLines
        @config.ignoreCommentedLines = ignoreCommentedLines
        @subscribeToBuffer()

  destroy: ->
    @unsubscribeFromBuffer()

  unsubscribeFromBuffer: ->
    if @buffer?
      @removeDecorations()
      @buffer.off 'contents-modified', @scheduleUpdate
      @buffer = null

  subscribeToBuffer: ->
    @unsubscribeFromBuffer()

    if @buffer = @editor.getBuffer()
      @scheduleUpdate()
      @buffer.on 'contents-modified', @scheduleUpdate

  scheduleUpdate: ->
    clearTimeout @updateTimer
    @updateTimer = setTimeout @updateColors, @config.updateInterval

  updateColors: =>
    console.info 'updating'
    @removeDecorations()

    # Is one of these more performant?
    # for line, index in @editor.getText().split('\n')
    #   matches = regexp.exec line
    # for line in [0...@editor.getLineCount()]
    #   matches = regexp.exec @editor.lineForBufferRow(line)
    for line in [0...@editor.getLineCount()]
      unless @config.ignoreCommentedLines and @editor.isBufferRowCommented(line)
        for regexp in RegExps
          match = regexp.exec @editor.lineForBufferRow(line)
          if match?
            @markLine line, match[1]
            break

  removeDecorations: ->
    return unless @markers?
    marker.destroy() for marker in @markers
    @markers = null

  markLine: (line, color) ->
    marker = @editor.markBufferPosition([line, 0], invalidate: 'never')
    @editor.decorateMarker(marker, type: 'gutter', class: 'color-gutter')
    @editorView.find('.line-number-' + line).css({ 'border-right-color': color })
    @markers ?= []
    @markers.push marker
