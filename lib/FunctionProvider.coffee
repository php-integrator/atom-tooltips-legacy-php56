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
    hoverEventSelectors: '.function-call:not(.object):not(.static), .support.function:not(.magic)'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            resolveTypeHandler = (type) =>
                successHandler = (functions) =>
                    if type?[0] != '\\'
                        type = '\\' + type

                    if functions and type of functions
                        resolve(Utility.buildTooltipForFunction(functions[type]))
                        return

                    reject()

                return @service.getGlobalFunctions().then(successHandler, failureHandler)

            return @service.resolveType(editor.getPath(), bufferPosition.row + 1, name, 'function').then(
                resolveTypeHandler,
                failureHandler
            )
