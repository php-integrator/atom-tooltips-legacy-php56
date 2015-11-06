Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for global functions.
##
class FunctionProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.function-call:not(.object):not(.static)'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        functions = @service.getGlobalFunctions()

        return unless functions and name of functions

        return Utility.buildTooltipForFunction(functions[name])
