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
    hoverEventSelectors: '.entity.inherited-class, .support.namespace, .support.class, .comment-clickable .region'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        fullClassName = @service.determineFullClassName(editor, name)

        try
            classInfo = @service.getClassInfo(fullClassName)

        catch
             return null

        return unless classInfo and classInfo.wasFound

        type = ''

        if classInfo.isClass
            type = (if classInfo.isAbstract then 'abstract ' else '') + 'class'

        else if classInfo.isTrait
            type = 'trait'

        else if classInfo.isInterface
            type = 'interface'

        # Create a useful description to show in the tooltip.
        description = ''

        description += "<p><div>"
        description +=     type + ' ' + '<strong>' + classInfo.shortName + '</strong> &mdash; ' + classInfo.class
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if classInfo.args.descriptions.short then classInfo.args.descriptions.short else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if classInfo.args.descriptions.long?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + classInfo.args.descriptions.long + "</div>"
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
