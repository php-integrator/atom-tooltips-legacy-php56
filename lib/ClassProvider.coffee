$ = require 'jquery'

AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for classes, traits, interfaces, ...
##
class ClassProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.entity.inherited-class, .support.namespace, .support.class'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        scopeChain = editor.scopeDescriptorForBufferPosition(bufferPosition).getScopeChain()

        try
            # Don't attempt to resolve class names in use statements.
            if scopeChain.indexOf('.support.other.namespace.use') == -1
                className = @service.resolveTypeAt(editor, bufferPosition, name)

            else
                className = name

            classInfo = @service.getClassInfo(className)

        catch error
            return null

        type = ''

        if classInfo.type == 'class'
            type = (if classInfo.isAbstract then 'abstract ' else '') + 'class'

        else if classInfo.type == 'trait'
            type = 'trait'

        else if classInfo.type == 'interface'
            type = 'interface'

        # Create a useful description to show in the tooltip.
        description = ''

        description += "<p><div>"
        description +=     type + ' ' + '<strong>' + classInfo.shortName + '</strong> &mdash; ' + classInfo.name
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if classInfo.descriptions.short then classInfo.descriptions.short else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if classInfo.descriptions.long?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + classInfo.descriptions.long + "</div>"
            description += "</div>"

        return description

    ###*
     * @inheritdoc
    ###
    getSelectorFromEvent: (event) ->
        return @service.getClassSelectorFromEvent(event)

    ###*
     * @inheritdoc
    ###
    getPopoverElementFromSelector: (selector) ->
        # getSelectorFromEvent can return multiple items because namespaces and class names are different HTML elements.
        # We have to select one to attach the popover to.
        array = $(selector).toArray()
        return array[array.length - 1]
