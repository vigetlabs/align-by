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
      selection = @editor().getSelectedText().trim()
      return if selection.length == 0

      currentRow       = @editor().getCursorBufferPosition().row
      selectionMapping = @generateSelectionMapping(selection)
      maxIndex         = @findMaxIndex(selectionMapping)
      firstLine        = Math.min.apply(Math, Object.keys(selectionMapping))
      lastLine         = Math.max.apply(Math, Object.keys(selectionMapping))
      newLines         = []

      for line, index of selectionMapping
        line   = parseInt(line)
        index  = parseInt(index)
        offset = @findOffset(maxIndex, index, line, selection)

        if line == currentRow
          startColumn = @textFor(line).indexOf(selection) + offset

        if offset > 0
          newLine = @textFor(line).replace(selection, " ".repeat(offset) + selection)
        else if offset == 0
          newLine = @textFor(line)
        else
          newLine = @textFor(line).replace(" ".repeat(offset * -1) + selection, selection)

        newLines.push(newLine)

      @editor().setTextInBufferRange([[firstLine, 0], [lastLine, Infinity]], newLines.join("\n"))
      @editor().setSelectedBufferRange([
        [currentRow, startColumn],
        [currentRow, startColumn + selection.length]
      ])

  findMaxIndex: (mapping) ->
    max = 0
    for line, index of mapping
      max = index if index > max

    max


  generateSelectionMapping: (selection) ->
    mapping = {}
    mapping[@currentFocus()] = @findIndex(@currentFocus(), selection)

    rowFocus = @currentFocus()
    while upperBound == undefined
      rowFocus -= 1
      index = @findIndex(rowFocus, selection)

      if index != -1
        mapping[rowFocus] = index
      else
        upperBound = rowFocus + 1

    rowFocus = @currentFocus()
    while lowerBound == undefined
      rowFocus += 1
      index = @findIndex(rowFocus, selection)

      if index != -1
        mapping[rowFocus] = index
      else
        lowerBound = rowFocus - 1

    mapping

  findIndex: (row, selection) ->
    lineText = @textFor(row) || ""
    regex    = new RegExp("\\s+" + selection)

    lineText.search(regex)


  findOffset: (maxIndex, index, line, selection) ->
    maxIndex - index - @numberOfLeadingSpaces(line, selection) + 1


  numberOfLeadingSpaces: (line, selection) ->
    @textFor(line).indexOf(selection) - @findIndex(line, selection)


  textFor: (line) ->
    @editor().lineTextForBufferRow(line)


  currentFocus: ->
    @editor().getCursorBufferPosition().row


  editor: ->
    atom.workspace.getActiveTextEditor()
