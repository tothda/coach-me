App.User = DS.Model.extend
  email: DS.attr('string')
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  role: DS.attr('string')
  public: DS.attr('boolean')
  createdAt: DS.attr('date')
  updatedAt: DS.attr('date')