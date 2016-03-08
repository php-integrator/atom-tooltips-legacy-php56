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
    hoverEventSelectors: '.entity.name.function, .support.function.magic'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            return @service.determineCurrentClassName(editor, bufferPosition, true).then (currentClassName) =>
                if currentClassName?
                    return @service.getClassInfo(currentClassName, true).then (classInfo) =>
                        if name of classInfo.methods
                            tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                            resolve(tooltipText)
                            return

                        reject()

                else
                    return @service.getGlobalFunctions(true).then (functions) =>
                        if functions and name of functions
                            resolve(Utility.buildTooltipForFunction(functions[name]))
                            return

                        reject()
