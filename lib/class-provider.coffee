$ = require 'jquery'

AbstractProvider = require './abstract-provider'

module.exports =

class ClassProvider extends AbstractProvider
    hoverEventSelectors: '.entity.inherited-class, .support.namespace, .support.class, .comment-clickable .region'

    ###*
     * Retrieves a tooltip for the word given.
     * @param  {TextEditor} editor         TextEditor to search for namespace of term.
     * @param  {string}     term           Term to search for.
     * @param  {Point}      bufferPosition The cursor location the term is at.
    ###
    getTooltipForWord: (editor, term, bufferPosition) ->
        fullClassName = @service.determineFullClassName(editor, term)
        classInfo = @service.getClassMembers(fullClassName)

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
     * Gets the correct selector when a class or namespace is clicked.
     *
     * @param  {jQuery.Event}  event  A jQuery event.
     *
     * @return {object|null} A selector to be used with jQuery.
    ###
    getSelectorFromEvent: (event) ->
        return @service.getClassSelectorFromEvent(event)

    ###*
     * Gets the correct element to attach the popover to from the retrieved selector.
     * @param  {jQuery.Event}  event  A jQuery event.
     * @return {object|null}          A selector to be used with jQuery.
    ###
    getPopoverElementFromSelector: (selector) ->
        # getSelectorFromEvent can return multiple items because namespaces and class names are different HTML elements.
        # We have to select one to attach the popover to.
        array = $(selector).toArray()
        return array[array.length - 1]
