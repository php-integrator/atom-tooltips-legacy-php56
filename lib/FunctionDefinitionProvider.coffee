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
    hoverEventSelectors: '.syntax--entity.syntax--name.syntax--function, .syntax--support.syntax--function.syntax--magic'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            successHandler = (currentClassName) =>
                if currentClassName?
                    successHandler = (classInfo) =>
                        if name of classInfo.methods
                            tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                            resolve(tooltipText)
                            return

                        reject()

                    return @service.getClassInfo(currentClassName).then(successHandler, failureHandler)

                else
                    successHandler = (functions) =>
                        if functions and name of functions
                            resolve(Utility.buildTooltipForFunction(functions[name]))
                            return

                        reject()

                    return @service.getGlobalFunctions().then(successHandler, failureHandler)

            return @service.determineCurrentClassName(editor, bufferPosition).then(successHandler, failureHandler)
