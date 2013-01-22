# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # hallo()
  initErrorModal()
  new ExerciseTable($('.exercise-table'))

class ExerciseTable
  constructor: (elem) ->
    @elem = $(elem)
    @trainingId = @elem.attr('data-training-id')
    @elem.on 'click', (event) =>
      this.edit($(event.target))

  edit: (cell) ->
    @editing.cancel() if @editing
    @editing = BaseCell.make(this, cell)
    @editing.edit()

  editingFinished: -> @editing = null
    
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
  
  constructor: (@table, @elem) ->
    @fnHours = "exercise[hours]"
    @fnMinutes = "exercise[minutes]"
    @fnSeconds = "exercise[seconds]"
    super @table, @elem

  makeFields: ->
    @hoursField = this.createNumericSelectUpTo(5,1).val(@hours)
    @minutesField = this.createNumericSelectUpTo(59).val(@minutes)
    @secondsField = this.createNumericSelectUpTo(59).val(@seconds)
    [@hoursField, $("<span> h </span>"), @minutesField, $("<span> m </span>"), @secondsField, $("<span> s </span>")]   
  
  serializeData: ->
    data = {}
    data[@fnHours] = @hoursField.val()
    data[@fnMinutes] = @minutesField.val()
    data[@fnSeconds] = @secondsField.val()
    data
    
  extractOrigData: ->
    data = {}
    timeValue = @elem.html()
      
    [@hours, @minutes, @seconds] = if timeValue == "-"
      [0,0,0]
    else
      (parseInt(x) for x in timeValue.split(":"))
      
    data[@fnHours] = @hours
    data[@fnMinutes] = @minutes
    data[@fnSeconds] = @seconds
    data

  renderData: (data) ->
    [h,m,s] = [data[@fnHours], data[@fnMinutes], data[@fnSeconds]]

    if h == 0 && m == 0 && s == 0
      @elem.html("-")
    else
      @elem.html("#{data[@fnHours]}:#{pad(data[@fnMinutes],2)}:#{pad(data[@fnSeconds],2)}")

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