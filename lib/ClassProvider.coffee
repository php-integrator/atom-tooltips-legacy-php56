Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for classes, traits, interfaces, ...
##
class ClassProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.entity.name.type.class, .entity.inherited-class, .support.namespace, .support.class'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            scopeChain = editor.scopeDescriptorForBufferPosition(bufferPosition).getScopeChain()

            failureHandler = () =>
                reject()

            successHandler = (currentClassName) =>
                successHandler = (classInfo) =>
                    tooltipText = Utility.buildTooltipForClasslike(classInfo)

                    resolve(tooltipText)

                firstPromise = null

                # Don't attempt to resolve class names in use statements. Note that scope descriptors for trait use
                # statements and actual "import" use statements are the same, so we have no choice but to use class
                # information for this: if we are inside a class, we can't be looking at a use statement.
                if scopeChain.indexOf('.support.other.namespace.use') == -1 or currentClassName?
                    firstPromise = @service.resolveTypeAt(editor, bufferPosition, name, 'classlike')

                else
                    firstPromise = new Promise (resolve, reject) ->
                        resolve(name)

                firstPromiseHandler = (name) =>
                    return @service.getClassInfo(name).then(successHandler, failureHandler)

                return firstPromise.then(firstPromiseHandler, failureHandler)

            return @service.determineCurrentClassName(editor, bufferPosition).then(successHandler, failureHandler)

    ###*
     * @inheritdoc
    ###
    getSelectorFromEvent: (event) ->
        return @getClassSelectorFromEvent(event)

    ###*
     * Gets the correct selector for the class or namespace that is part of the specified event.
     *
     * @param {jQuery.Event} event A jQuery event.
     *
     * @return {object|null} A selector to be used with jQuery.
    ###
    getClassSelectorFromEvent: (event) ->
        selector = event.currentTarget

        $ = require 'jquery'

        if $(selector).parent().hasClass('function argument')
            return $(selector).parent().children('.namespace, .class:not(.operator):not(.constant)')

        if $(selector).prev().hasClass('namespace') && $(selector).hasClass('class')
            return $([$(selector).prev()[0], selector])

        if $(selector).next().hasClass('class') && $(selector).hasClass('namespace')
           return $([selector, $(selector).next()[0]])

        if $(selector).prev().hasClass('namespace') || $(selector).next().hasClass('inherited-class')
            return $(selector).parent().children('.namespace, .inherited-class')

        if $(selector).next().hasClass('constant') && $(selector).hasClass('namespace')
           return null

        return selector

    ###*
     * @inheritdoc
    ###
    getPopoverElementFromSelector: (selector) ->
        $ = require 'jquery'

        # getSelectorFromEvent can return multiple items because namespaces and class names are different HTML elements.
        # We have to select one to attach the popover to.
        array = $(selector).toArray()
        return array[array.length - 1]
