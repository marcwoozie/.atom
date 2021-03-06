{View} = require 'atom-space-pen-views'
path = require 'path'

module.exports =
class ProjectManagerAddView extends View
  projectManager: null

  @content: ->
    @div class: 'project-manager', =>
      @div class: 'editor-container', outlet: 'editorContainer', =>
        @div =>
          @input outlet:'editor', class:'native-key-bindings', placeholderText: 'Project title'
        @div =>
          @span 'Path: '
          @span class: 'text-highlight', atom.project?.getPath()

  initialize: ->
    @editor.on 'core:confirm', @confirm
    @editor.on 'core:cancel', @hide
    @editor.on 'blur', @hide

  cancelled: =>
    @hide()

  confirm: =>
    project =
      title: @editor.val()
      paths: [atom.project?.getPath()]

    @projectManager.addProject(project) if project.title
    @hide() if project.title

  hide: =>
    atom.commands.dispatch(atom.views.getView(atom.workspace), 'focus')
    @panel.hide()

  show: =>
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    basename = path.basename(atom.project.getPath())
    @editor.val(basename)
    @editor.focus()
    @editor.select()

  toggle: (projectManager) ->
    @projectManager = projectManager
    if @panel?.isVisible()
      @hide()
    else
      @show()
