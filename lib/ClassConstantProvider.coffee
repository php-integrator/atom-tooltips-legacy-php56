Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member constants.
##
class ClassConstantProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.constant.other.class'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            className = @service.getResultingTypeAt(editor, bufferPosition, true)

            return @service.getClassInfo(className, true).then (classInfo) =>
                if name of classInfo.constants
                    tooltipText = Utility.buildTooltipForConstant(classInfo.constants[name])

                    resolve(tooltipText)

                reject()
