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
            try
                className = @service.getResultingTypeAt(editor, bufferPosition, true)

            catch error
                reject()
                return

            successHandler = (classInfo) =>
                if name of classInfo.methods
                    tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                    resolve(tooltipText)
                    return

                reject()

            failureHandler = () =>
                reject()

            return @service.getClassInfo(className, true).then(successHandler, failureHandler)
