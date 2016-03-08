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
        return new Promise (resolve, reject) =>
            return @service.getGlobalFunctions(true).then (functions) =>
                if functions and name of functions
                    resolve(Utility.buildTooltipForFunction(functions[name]))
                    return

                reject()
