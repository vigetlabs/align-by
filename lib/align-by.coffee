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
      selection    = @editor().getSelectedText()
      selectionMapping = {}
      selectionMapping[@currentFocus()] = @textFor(@currentFocus()).indexOf(selection)

      rowFocus = @currentFocus()
      while upperBound == undefined
        rowFocus -= 1
        index = @textFor(rowFocus).indexOf(selection)

        if index != -1
          selectionMapping[rowFocus] = index
        else
          upperBound = rowFocus + 1

      rowFocus = @currentFocus()
      while lowerBound == undefined
        rowFocus += 1
        index = @textFor(rowFocus).indexOf(selection)

        if index != -1
          selectionMapping[rowFocus] = index
        else
          lowerBound = rowFocus - 1

    console.log(selectionMapping)

  textFor: (row) ->
    @editor().lineTextForBufferRow(row) || ""

  currentFocus: ->
    @editor().getCursorBufferPosition().row

  editor: ->
    atom.workspace.getActiveTextEditor()
