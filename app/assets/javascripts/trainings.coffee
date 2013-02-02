# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#training-show-page').each ->
    editor = new TrainingEditor($(this))
    if location.hash == '#/edit'
      editor.startEdit()
    initErrorModal()
    new ExerciseTable($('.exercise-table'))
    new ExerciseForm($('.exercise-form-row'))

class ExerciseTable
  constructor: (elem) ->
    @elem = $(elem)
    @trainingId = @elem.attr('data-training-id')
    @elem.on 'click', '.field', (event) =>
      this.edit($(event.target))
    @elem.on 'click', '.delete-exercise', (event) =>
      this.deleteExercise($(event.target))

  edit: (cell) ->
    @editing.cancel() if @editing
    @editing = BaseCell.make(this, cell)
    @editing.edit()

  editingFinished: -> @editing = null

  deleteExercise: (cell)->
    if !confirm("Are you sure?")
      return false

    row = cell.closest('tr')
    exerciseId = row.attr('data-exercise-id')
    trainingId =  $('#training-show-page').attr('data-training-id')
    $.ajax
      url: "/trainings/#{trainingId}/exercises/#{exerciseId}"
      type: 'DELETE'
      dataType: 'json'
      success: =>
        row.remove()
        false
      error: =>
        showErrorModal()
        false        
    
class BaseCell
  constructor: (@table, @elem) ->
    @origData = this.extractOrigData()
    @fields = this.makeFields()
    @saveButton = $('<button class="btn btn-primary" style="margin: 0 5px 10px 5px">Save</button>')
    @saveButton.click => this.save()
    @cancelLink = $('<a href="#" style="margin-bottom: 5px">cancel</a>')
    @cancelLink.click => this.cancel()
    @exerciseId = @elem.closest('tr').attr('data-exercise-id')

  makeFields: -> throw "Implement in subclasses!"
  serializeData: -> throw "Implement in subclasses!"
  extractOrigData: -> throw "Implement in subclasses!"
  renderData: -> throw "Implement in subclasses!"
  
  @make: (table, elem) ->
    if elem.hasClass('exercise-name')
      new SimpleFieldCell(table, elem, "name")
    else if elem.hasClass('exercise-distance')
      new SimpleFieldCell(table, elem, "distance")
    else if elem.hasClass('exercise-time')
      new TimeCell(table, elem)
    else
      throw 'Not yet implemented!'
    
  edit: ->
    @elem.html('')
      .append(@fields)
      .append(@saveButton)
      .append(@cancelLink)

    @fields[0].select()

    @elem.on 'click.exerciseCell', -> false
    false

  cancel: ->
    this.renderData(@origData)
    this.finishEditing()
    false

  finishEditing: ->
    @elem.off 'click.exerciseCell'
    @table.editingFinished()
    
  save: ->
      @saveButton.replaceWith('Saving...')
      newData = this.serializeData()
      $.ajax
        url: "/trainings/#{@table.trainingId}/exercises/#{@exerciseId}"
        data: newData
        type: 'PUT'
        success: =>
          this.renderData(newData)
          this.finishEditing()
          false
        error: =>
          showErrorModal()
          false

class SimpleFieldCell extends BaseCell
  constructor: (@table, @elem, name) ->
    @fieldName = "exercise[#{name}]"
    super @table, @elem
    
  makeFields: ->
    @field = $('<input type=text />').val(@elem.html())
    [@field]    
  
  serializeData: ->
    data = {}
    data[@fieldName] = @field.val()
    data
    
  extractOrigData: ->
    data = {}
    data[@fieldName] = @elem.html()
    data

  renderData: (data) ->
    @elem.html(data[@fieldName])
      
class TimeCell extends BaseCell
  @fnHours = "exercise[hours]"
  @fnMinutes = "exercise[minutes]"
  @fnSeconds = "exercise[seconds]"
  
  constructor: (@table, @elem) ->
    super @table, @elem

  makeFields: ->
    @hoursField = this.createNumericSelectUpTo(5,1).val(@hours)
    @minutesField = this.createNumericSelectUpTo(59).val(@minutes)
    @secondsField = this.createNumericSelectUpTo(59).val(@seconds)
    [@hoursField, $("<span> h </span>"), @minutesField, $("<span> m </span>"), @secondsField, $("<span> s </span>")]   
  
  serializeData: ->
    data = {}
    data[TimeCell.fnHours] = @hoursField.val()
    data[TimeCell.fnMinutes] = @minutesField.val()
    data[TimeCell.fnSeconds] = @secondsField.val()
    data
    
  extractOrigData: ->
    data = {}
    timeValue = @elem.html()
      
    [@hours, @minutes, @seconds] = if timeValue == "-"
      [0,0,0]
    else
      (parseInt(x) for x in timeValue.split(":"))
      
    data[TimeCell.fnHours] = @hours
    data[TimeCell.fnMinutes] = @minutes
    data[TimeCell.fnSeconds] = @seconds
    data

  renderData: (data) ->
    val = TimeCell.renderTime(data)
    @elem.html(val)
    
  @renderTime: (data, elem) ->
    [h,m,s] = [data[TimeCell.fnHours], data[TimeCell.fnMinutes], data[TimeCell.fnSeconds]]

    if h == 0 && m == 0 && s == 0
      "-"
    else
      "#{data[TimeCell.fnHours]}:#{pad(data[TimeCell.fnMinutes],2)}:#{pad(data[TimeCell.fnSeconds],2)}"

  createNumericSelectUpTo: (n, l = 2) ->
    options = ("<option value='#{i}'>#{pad(i,l)}</option>" for i in [0..n])
    select = $("<select style='width: 50px'>#{options.join()}</select>");
    select

initErrorModal = ->
  modal = $('#errorModal')
  modal.on 'hide', => location.reload(true)

showErrorModal = ->
  $('#errorModal').modal
    backdrop: false

# https://gist.github.com/1180489
pad = (a,b) -> ([1e15] + a).slice(-b)

#------------------------------
# Training Editor
#------------------------------
class TrainingEditor
  fTitle: 'training[title]'
  fNotes: 'training[notes]'
  fDate: 'training[started_at]'
  fFeeling: 'training[feeling]'
  fTemperature: 'training[temperature]'
  fWeather: 'training[weather]'
  fSurface: 'training[surface]'
  
  constructor: (@page)->
    @trainingId = @page.attr('data-training-id')
    @buttonBar = @page.find('.button-bar')
    @editButton = @buttonBar.find('.edit-button')
    
    @title = @page.find('.training-title')
    @notes = @page.find('.training-notes')
    @date = @page.find('.training-date')
    @feeling = @page.find('.training-feeling')
    @temperature = @page.find('.training-temperature')
    @weather = @page.find('.training-weather')
    @surface = @page.find('.training-surface')
  
    @saveButton = $('<button class="btn btn-success"><i class="icon-ok"></i><span></span></button>')
    @cancelButton = $('<button class="btn"><i class=""></i> Cancel</button>')
    @titleEditor = $('<input type="text" class="span8" style="font-size:24px;font-weight:bold;color:black;margin:0;height:26px" />')
    @notesEditor = $("<textarea style='width: 100%; height: 141px'></textarea>")
    @dateEditor = $('<input type="text" style="font-size:18px;font-weight:bold;color:black" class="input-small" placeholder="yyyy.mm.dd" data-behaviour="datepicker" />')
    @feelingEditor = this.createSelect(feelingValues)
    @temperatureEditor = this.createSelect(temperatureValues)
    @weatherEditor = this.createSelect(weatherValues)
    @surfaceEditor = this.createSelect(surfaceValues)
    
    @editButton.click => this.startEdit()

  createSelect: (options) ->
    optionStrings = ("<option value='#{o.value}'>#{o.label}</option>" for o in options)
    select = $("<select style='height:25px; width: 100%; margin:2px 0 0 0'><option></option>#{optionStrings.join()}</select>");
    select
    
  collectOrigData: ->
    data = {}
    data[@fTitle] = @title.find('h2').html().trim() || ""
    data[@fNotes] = @notes.find('.well').html().trim() || ""
    data[@fDate] = @date.text().trim() || ""
    data[@fFeeling] = @feeling.text().trim() || ""
    data[@fTemperature] = @temperature.text().trim() || ""
    data[@fWeather] = @weather.text().trim() || ""
    data[@fSurface] = @surface.text().trim() || ""
    data

  collectData: ->
    data = {}
    data[@fTitle] = @titleEditor.val()
    data[@fNotes] = @notesEditor.val()
    data[@fDate] = @dateEditor.val()
    data[@fFeeling] = @feelingEditor.val()
    data[@fTemperature] = @temperatureEditor.val()
    data[@fWeather] = @weatherEditor.val()
    data[@fSurface] = @surfaceEditor.val()
    data
    
  startEdit: ->
    removeAlerts()
    @origData = this.collectOrigData()
    @titleEditor.val(@origData[@fTitle])
    @notesEditor.val(@origData[@fNotes])
    @dateEditor.val(@origData[@fDate])
    @feelingEditor.val(@origData[@fFeeling])
    @temperatureEditor.val(@origData[@ftemperature])
    @weatherEditor.val(@origData[@fWeather])
    @surfaceEditor.val(@origData[@fSurface])
    
    @title.html(@titleEditor)
    @notes.html(@notesEditor)
    @date.html(@dateEditor)
    @feeling.html(@feelingEditor)
    @temperature.html(@temperatureEditor)
    @weather.html(@weatherEditor)
    @surface.html(@surfaceEditor)

    @titleEditor.select()

    this.startEditing()
    false

  cancel: ->
    this.stopEditing()
    this.render(@origData)

  stopEditing: ->
    @saveButton.before(@editButton).remove()
    @cancelButton.remove()
    @editButton.click => this.startEdit()
    location.hash = '' if location.hash == '#/edit'
    $(window).off 'unload.training-editor'

  startEditing: ->
    @saveButton.removeClass('disabled').find('span').html(' Save training')
    @editButton.after(@saveButton, @cancelButton).remove()
    @cancelButton.click => this.cancel()
    @saveButton.click =>
      @saveButton.addClass('disabled').find('span').html(' Saving...')
      this.save()
      false
    location.hash = '/edit' if location.hash == ''
    $(window).unload =>
      confirm("Do you want to leave without saving?") 
        
  render: (data) ->
    @title.html("<h2>#{data[@fTitle]}</h2>")
    @notes.html("<div class='well'>#{data[@fNotes]}</div>")
    @date.html("#{data[@fDate]}")
    @feeling.html("<span>#{this.selectedOptionText(@feelingEditor)}</span>")
    @temperature.html("<span>#{this.selectedOptionText(@temperatureEditor)}</span>")
    @weather.html("<span>#{this.selectedOptionText(@weatherEditor)}</span>")
    @surface.html("<span>#{this.selectedOptionText(@surfaceEditor)}</span>")

  selectedOptionText: (select)->
    select.find(':selected').text()
    
  save: ->
    data = this.collectData()
    $.ajax
      url: "/trainings/#{@trainingId}"
      type: 'PUT'
      dataType: 'json'
      data: data
      success: =>
        this.stopEditing()
        this.render(data)
        makeAlert('Changes have been saved.', 'success')
        false
      error: =>
        makeAlert('Ooops, something bad happened. We could not save your changes.', 'error')
        false
    false

class ExerciseForm
  fName: 'exercise[name]'
  fDistance: 'exercise[distance]'
  fHours: 'exercise[hours]'
  fMinutes: 'exercise[minutes]'
  fSeconds: 'exercise[seconds]'
  
  constructor: (@container) ->
    @button = @container.find('button')
    @trainingId = $('#training-show-page').attr('data-training-id')
    @fields = [@fName, @fDistance, @fHours, @fMinutes, @fSeconds]
    @button.click =>
      this.submit()
      false
    @table = $('.exercise-table')

  serialize: ->
    data = {}
    for field in @fields
      data[field] = this.extractValueFor(field)
    data

  extractValueFor: (name) -> @container.find("[name='#{name}']").val()
    
  submit: ->
    data = this.serialize()
    $.ajax
      url: "/trainings/#{@trainingId}/exercises"
      type: 'POST'
      dataType: 'json'
      data: data
      success: (resp) =>
        this.makeNewRow(resp, data)
        false
      error: =>
        showErrorModal()
        false

  makeNewRow: (resp, data)->
    newRow = $("""
<tr data-exercise-id='#{resp.id}'>
  <td class='field exercise-name'>#{data[@fName]}</td>
  <td class='field exercise-distance'>#{data[@fDistance]}</td>
  <td class='field exercise-time'>#{TimeCell.renderTime(data)}</td>
  <td class='delete-exercise'><button class='btn btn-mini'><i class='icon-trash'></i></button></td>
</tr>
    """)
    @table.append(newRow)

makeAlert = (text, type, closable = true) ->
  removeAlerts()
  alert = $("<div class='alert alert-#{type}'><p>#{text}</p></div>")
  if closable
    alert.prepend($("<button class='close' data-dismiss='alert'>x</button>"))
  $('#messages').append(alert)

removeAlerts = () ->
  $('#messages .alert').remove()