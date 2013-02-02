App.StarView = Em.View.extend
  tagName: 'span'
  classNames: ['star-view']
  rate: 0 # 0 - 5: number of stars
  template: Em.Handlebars.compile('{{#each x in view.icons}}<i {{bindAttr class="x"}}> </i>{{/each}}')
  
  icons: Em.computed ->
    rate = @get('rate')
    full = ("icon-star" for x in [0...rate])
    empty = ("icon-star-empty" for x in [0...(rate-5)])
    full.concat(empty)
  .property('rate')
  