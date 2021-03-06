Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for global constants.
##
class ClassProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.syntax--function-call.syntax--object, .syntax--function-call.syntax--static'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            resultingTypeSuccessHandler = (types) =>
                if types.length == 0
                    reject()
                    return

                successHandler = (classInfoArray) =>
                    for classInfo in classInfoArray
                        if name of classInfo.methods
                            tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                            resolve(tooltipText)
                            return

                    reject()

                promises = []

                for type in types
                    promises.push @service.getClassInfo(type)

                Promise.all(promises).then(successHandler, failureHandler)

            return @service.getResultingTypesAt(editor, bufferPosition, true).then(
                resultingTypeSuccessHandler,
                failureHandler
            )
