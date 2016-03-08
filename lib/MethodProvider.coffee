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
            className = @service.getResultingTypeAt(editor, bufferPosition, true)

            return @service.getClassInfo(className, true).then (classInfo) =>
                if name of classInfo.methods
                    tooltipText = Utility.buildTooltipForFunction(classInfo.methods[name])

                    resolve(tooltipText)
                    return

                reject()
