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
    hoverEventSelectors: '.function-call.object, .function-call.static'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            resultingTypeSuccessHandler = (className) =>
                if not className?
                    reject()
                    return

                successHandler = (classInfo) =>
                    if name of classInfo.methods
                        tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                        resolve(tooltipText)
                        return

                    reject()

                return @service.getClassInfo(className).then(successHandler, failureHandler)

            return @service.getResultingTypeAt(editor, bufferPosition, true).then(resultingTypeSuccessHandler, failureHandler)
