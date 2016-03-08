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
            try
                functions = @service.getGlobalFunctions()

            catch
                 reject()
                 return

            if not functions or name not of functions
                reject()
                return

            resolve(Utility.buildTooltipForFunction(functions[name]))
