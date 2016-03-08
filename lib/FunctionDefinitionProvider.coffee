Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips on function and method definitions.
##
class FunctionDefinitionProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.entity.name.function'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            try
                currentClassName = @service.determineCurrentClassName(editor, bufferPosition)

            catch error
                reject()
                return

            value = null

            try
                if currentClassName?
                    value = @service.getClassMethod(currentClassName, name)

                else
                    globalFunctions = @service.getGlobalFunctions()

                    if name of globalFunctions
                        value = globalFunctions[name]

            catch error
                reject()
                return

            if not value?
                reject()
                return

            resolve(Utility.buildTooltipForFunction(value))
