{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'align-by:align': => @align()

  deactivate: ->
    @subscriptions.dispose()

  align: ->
    if @editor()
      selection        = @editor().getSelectedText()
      selectionMapping = @generateSelectionMapping(selection)
      maxIndex         = @findMaxIndex(selectionMapping)

      for line, index of selectionMapping
        line  = parseInt(line)
        index = parseInt(index)

        if index < maxIndex
          @editor().setTextInBufferRange([[line, index],[line, index]], " ".repeat(maxIndex - index))


  findMaxIndex: (mapping) ->
    max = 0
    for line, index of mapping
      max = index if index > max

    max


  generateSelectionMapping: (selection) ->
    mapping = {}
    mapping[@currentFocus()] = @textFor(@currentFocus()).indexOf(selection)

    rowFocus = @currentFocus()
    while upperBound == undefined
      rowFocus -= 1
      index = @textFor(rowFocus).indexOf(selection)

      if index != -1
        mapping[rowFocus] = index
      else
        upperBound = rowFocus + 1

    rowFocus = @currentFocus()
    while lowerBound == undefined
      rowFocus += 1
      index = @textFor(rowFocus).indexOf(selection)

      if index != -1
        mapping[rowFocus] = index
      else
        lowerBound = rowFocus - 1

    mapping


  textFor: (row) ->
    @editor().lineTextForBufferRow(row) || ""


  currentFocus: ->
    @editor().getCursorBufferPosition().row


  editor: ->
    atom.workspace.getActiveTextEditor()
