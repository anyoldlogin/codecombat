View = require 'views/kinds/ModalView'
template = require 'templates/play/level/modal/multiplayer'
{me} = require('lib/auth')

module.exports = class MultiplayerModal extends View
  id: 'level-multiplayer-modal'
  template: template

  events:
    'click textarea': 'onClickLink'
    'change #multiplayer': 'updateLinkSection'

  constructor: (options) ->
    super(options)
    @session = options.session
    @session.on 'change:multiplayer', @updateLinkSection
    @playableTeams = options.playableTeams

  getRenderData: ->
    c = super()
    c.joinLink = (document.location.href.replace(/\?.*/, '').replace('#', '') +
      '?session=' +
      @session.id)
    c.multiplayer = @session.get('multiplayer')
    c.playableTeams = @playableTeams
    c

  afterRender: ->
    super()
    @updateLinkSection()
    @$el.find('#multiplayer-team-selection input')
      .prop('checked', -> $(@).val() is me.team)
      .bind('change', -> Backbone.Mediator.publish 'level:set-team', team: $(@).val())

  onClickLink: (e) ->
    e.target.select()

  updateLinkSection: =>
    multiplayer = @$el.find('#multiplayer').prop('checked')
    la = @$el.find('#link-area')
    if multiplayer then la.show() else la.hide()
    true

  onHidden: ->
    multiplayer = Boolean(@$el.find('#multiplayer').prop('checked'))
    @session.set('multiplayer', multiplayer)
