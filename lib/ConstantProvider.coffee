Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member methods.
##
class MethodProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.constant.other.php, .support.other.namespace.php'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            successHandler = (constants) =>
                if name?[0] != '\\'
                    name = '\\' + name

                if constants and name of constants
                    resolve(Utility.buildTooltipForConstant(constants[name]))
                    return

                reject()

            failureHandler = () =>
                reject()

            return @service.getGlobalConstants().then(successHandler, failureHandler)

    ###*
     * @inheritdoc
    ###
    getSelectorFromEvent: (event) ->
        return @getClassSelectorFromEvent(event)

    ###*
     * Gets the correct selector for the constant that is part of the specified event.
     *
     * @param {jQuery.Event} event A jQuery event.
     *
     * @return {object|null} A selector to be used with jQuery.
    ###
    getClassSelectorFromEvent: (event) ->
        selector = event.currentTarget

        $ = require 'jquery'

        if $(selector).prev().hasClass('namespace') && $(selector).hasClass('constant')
            return $([$(selector).prev()[0], selector])

        if $(selector).next().hasClass('constant') && $(selector).hasClass('namespace')
            return $([selector, $(selector).next()[0]])

        return $(selector)

    ###*
     * @inheritdoc
    ###
    getPopoverElementFromSelector: (selector) ->
        $ = require 'jquery'

        # getSelectorFromEvent can return multiple items because namespaces and constants are different HTML elements.
        # We have to select one to attach the popover to.
        array = $(selector).toArray()
        return array[array.length - 1]
