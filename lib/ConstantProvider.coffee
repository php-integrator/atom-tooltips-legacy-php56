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
    hoverEventSelectors: '.syntax--constant.syntax--other.syntax--php, .syntax--support.syntax--other.syntax--namespace.syntax--php'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            resolveTypeHandler = (type) =>
                successHandler = (constants) =>
                    if type?[0] != '\\'
                        type = '\\' + type

                    if constants and type of constants
                        resolve(Utility.buildTooltipForConstant(constants[type]))
                        return

                    reject()

                return @service.getGlobalConstants().then(successHandler, failureHandler)

            return @service.resolveType(editor.getPath(), bufferPosition.row + 1, name, 'constant').then(
                resolveTypeHandler,
                failureHandler
            )

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
